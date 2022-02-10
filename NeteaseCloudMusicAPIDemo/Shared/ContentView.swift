//
//  ContentView.swift
//  Shared
//
//  Created by teenloong on 2022/2/2.
//

import SwiftUI
import NeteaseCloudMusicAPI
import RxNeteaseCloudMusicAPI
import Combine
import RxSwift

struct ContentView: View {
    @State private var cancells = Set<AnyCancellable>()
    @State private var disposeBag = DisposeBag()

    @State private var id: Int = 507712546

    var body: some View {
        VStack {
            TextField("Playlist ID", value: $id, formatter: NumberFormatter()) { isEidting in
                
            } onCommit: {
                
            }

            Button {
                callback()
            } label: {
                Text("Callback")
            }
            .padding()
            Button {
                combine()
            } label: {
                Text("Combine")
            }
            .padding()
            Button {
                asyncRequest()
            } label: {
                Text("Async")
            }
            .padding()
            Button {
                rxswift()
            } label: {
                Text("Rxswift")
            }
            .padding()
            Spacer()
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
    }
    
    func callback() {
        NCM.request(action: NCMPlaylistDetailAction(id: id)) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func combine() {
        NCM.requestPublisher(action: NCMPlaylistDetailAction(id: id)).sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print(error)
            }
        }, receiveValue: { response in
            print(response)
        }).store(in: &cancells)
    }

    func asyncRequest() {
        #if canImport(UIKit)
        if #available(iOS 15.0, *) {
            Task {
                let result = await NCM.requestAsync(action: NCMPlaylistDetailAction(id: id))
                print(result)
            }
        }
        #endif
        #if canImport(AppKit)
        if #available(macOS 12.0, *) {
            Task {
                let result = await NCM.requestAsync(action: NCMPlaylistDetailAction(id: id))
                print(result)
            }
        }
        #endif
    }
    
    func rxswift() {
        NCM.requestObserver(action: NCMPlaylistDetailAction(id: id)).subscribe { response in
            print(response)
        } onFailure: { error in
            print(error)
        } onDisposed: {

        }.disposed(by: disposeBag)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
