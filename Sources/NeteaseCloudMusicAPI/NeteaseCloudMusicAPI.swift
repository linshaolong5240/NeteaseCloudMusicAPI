//
//  NeteaseCloudMusicAPI.swift
//  NeteaseCloudMusicAPI
//
//  Created by teenloong on 2020/5/1.
//  Copyright © 2022 com.teenloong. All rights reserved.
//
import Foundation
import CryptoSwift
import Security
import Combine

public enum NCMHttpMethod: String {
    case get
    case post
}

public let NCM = NeteaseCloudMusicAPI.shared

public class NeteaseCloudMusicAPI {

    public static let shared = NeteaseCloudMusicAPI()
    
    private var requestHttpHeader = [ //"Accept": "*/*",
        //"Accept-Encoding": "gzip,deflate,sdch",
        //"Connection": "keep-alive",
        "Content-Type": "application/x-www-form-urlencoded",
        "Host": "music.163.com",
        "Referer": "https://music.163.com",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Safari/605.1.15"
    ]
    
    public init() {
        let cookie = HTTPCookie(properties: [.name : "os",
                                             .value: "pc",
                                             .domain: ".music.163.com",
                                             .path: "/"])
        let cookie2 = HTTPCookie(properties: [.name : "appver",
                                             .value: "2.7.1.198277",
                                             .domain: ".music.163.com",
                                             .path: "/"])
        HTTPCookieStorage.shared.setCookie(cookie!)
        HTTPCookieStorage.shared.setCookie(cookie2!)
    }
    
    private func encrypto(text: String) -> String {
        func generateSecretKey(size: Int) -> String {
            let base62 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            
            var key = ""
            for _ in 1...size {
                key.append(base62.randomElement()!)
            }
            return key
        }
        func aesEncrypt(text: String, key: String, iv: String) -> String? {
            do {
                let aes = try AES(key: Array<UInt8>(key.utf8), blockMode: CBC(iv: Array<UInt8>(iv.utf8)))
                let bytes = try aes.encrypt(Array(text.utf8))
                let data = Data(bytes: bytes, count: bytes.count)
                return data.base64EncodedString()
            }catch {
                return nil
            }
        }
        func rsaEncrypt(text: String, pubKey: String) -> String {
            //        let keyString = pubKey.replacingOccurrences(of: "-----BEGIN RSA PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END RSA PUBLIC KEY-----", with: "")
            let keyData = Data(base64Encoded: pubKey)
            
            var attributes: CFDictionary {
                return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                        kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                        kSecAttrKeySizeInBits   : 1024,
                        kSecReturnPersistentRef : kCFBooleanTrue!] as CFDictionary
            }
            
            var error: Unmanaged<CFError>?
            let secKey = SecKeyCreateWithData(keyData! as CFData, attributes, &error)
            
            let encryptData = SecKeyCreateEncryptedData(secKey!,
                                                        SecKeyAlgorithm.rsaEncryptionRaw,
                                                        text.data(using: .utf8)! as CFData,
                                                        &error)
            let data = encryptData! as Data
            #if DEBUG
            print(error ?? "")
            #endif
            return data.toHexString()
        }
        //crypto
        let pubKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ34ZC28NWYpAUd98iZ37BUrX/aKzmFbt7clFSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvaklV8k4cBFK9snQXE9/DDaFt6Rr7iVZMldczhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44oncaTWz7OBGLbCiK45wIDAQAB"

        let nonce = "0CoJUm6Qyw8W8jud"
        let iv = "0102030405060708"

        let secKey = generateSecretKey(size: 16)
        let encText = aesEncrypt(text: aesEncrypt(text: text, key: nonce, iv: iv)!, key: secKey, iv: iv)
        let encSecKey = rsaEncrypt(text: String(secKey.reversed()), pubKey: pubKey)
        return "params=\(encText!)&encSecKey=\(encSecKey)".plusSymbolToPercent()
    }
    
    private func makeRequest<Action: NCMAction>(action: Action) -> URLRequest {
        let url: String =  action.host + action.uri
        if let headers = action.headers {
            requestHttpHeader.merge(headers) { current, new in
                new
            }
        }
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = action.method.rawValue
        request.allHTTPHeaderFields = requestHttpHeader
        request.timeoutInterval = action.timeoutInterval
        if action.method == .post {
            if let data = try? JSONEncoder().encode(action.parameters) {
                if let str = String(data: data, encoding: .utf8) {
                    request.httpBody = encrypto(text: str).data(using: .utf8)
                }
            }
        }
        
//        let cookies = HTTPCookieStorage.shared.cookies
//        let cookiesString = cookies!.map({ cookie in
//            cookie.name + "=" + cookie.value
//        }).joined(separator: "; ")
//        httpHeader["Cookie"] = cookiesString
//        print(httpHeader)
        return request
    }
    
    @discardableResult
    public func request<Action: NCMAction>(action: Action, completion: @escaping (Result<Action.Response?, Error>) -> Void) -> URLSessionDataTask {
        let request = makeRequest(action: action)
        
        let task = URLSession.shared.dataTask(with: request) { responseData, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                guard let data = responseData, !data.isEmpty else {
                    completion(.success(nil))
                    return
                }

                do {
                    let model = try JSONDecoder().decode(action.responseType, from: data)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        return task
    }
}

@available(iOS 13.0, *)
@available(macOS 11.0, *)
extension NeteaseCloudMusicAPI {
    public func requestPublisher<Action: NCMAction>(action: Action) -> AnyPublisher<Action.Response, Error> {
        let request = makeRequest(action: action)

        #if false
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map {
                let str = String(data: $0.data, encoding: .utf8)?.jsonToDictionary?.toJSONString
                print(str ?? "data: nil")
                return $0.data
            }
            .decode(type: action.responseType, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        #else
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: action.responseType, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        #endif
    }
    
    public func uploadPublisher(action: NCMCloudUploadAction) -> AnyPublisher<NCMCloudUploadResponse, Error> {
        let url: String =  action.host + action.uri
        if let headers = action.headers {
            requestHttpHeader.merge(headers) { current, new in
                new
            }
        }
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = action.method.rawValue
        request.allHTTPHeaderFields = action.headers
        request.httpBody = action.data
        #if false
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map {
                print(String(data: $0.data, encoding: .utf8)?.jsonToDictionary?.toJSONString)
                return $0.data
            }
            .decode(type: action.responseType, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        #else
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: action.responseType, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        #endif
    }
}

@available(iOS 15.0, *)
@available(macOS 12.0, *)
extension NeteaseCloudMusicAPI {
    public func requestAsync<Action: NCMAction>(action: Action) async -> Result<Action.Response, Error> {
        let request = makeRequest(action: action)

        do {
            let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
            let model = try JSONDecoder().decode(action.responseType, from: data)
            return .success(model)
        }catch let error {
            return .failure(error)
        }
    }
    
    public func uploadAsync(action: NCMCloudUploadAction) async -> Result<NCMCloudUploadResponse, Error> {
        let url: String =  action.host + action.uri
        if let headers = action.headers {
            requestHttpHeader.merge(headers) { current, new in
                new
            }
        }
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = action.method.rawValue
        request.allHTTPHeaderFields = action.headers
        request.httpBody = action.data
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
            let model = try JSONDecoder().decode(action.responseType, from: data)
            return .success(model)
        }catch let error {
            return .failure(error)
        }
    }
}

extension String {
    func plusSymbolToPercent() -> String {
        return self.replacingOccurrences(of: "+", with: "%2B")
    }
}

//getCSRFToken
extension NeteaseCloudMusicAPI {
    func getCSRFToken() -> String {
        if let cookies = HTTPCookieStorage.shared.cookies{
            for cookie in cookies {
                if cookie.name == "__csrf" {
                    return cookie.value
                }
            }
        }
        return ""
    }
}
