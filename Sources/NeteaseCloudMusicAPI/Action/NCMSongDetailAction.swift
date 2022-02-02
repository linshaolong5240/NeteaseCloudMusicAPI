//
//  NCMSongDetailAction.swift
//  Qin
//
//  Created by teenloong on 2021/6/8.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌曲详情
public struct NCMSongDetailAction: NCMAction {
    public struct SongDetailParameters: Encodable {
        public var c: String
        public var ids: String
        init(ids: [Int]) {
            let kv: String = ids.map{"{" + "id:" + String($0) + "}"}.joined(separator: ",")
            self.c = "[" + kv + "]"
            self.ids = "[" + ids.map(String.init).joined(separator: ",") + "]"
        }
    }
    public typealias Parameters = SongDetailParameters
    public typealias Response = NCMSongDetailResponse

    public var uri: String { "/weapi/v3/song/detail" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(ids: [Int]) {
        self.parameters = Parameters(ids: ids)
    }
}

public struct NCMSongDetailResponse: NCMResponse {
    public var code: Int
    public var privileges: [NCMPrivilegeResponse]
    public var songs: [NCMSongResponse]
    public var message: String?
}
