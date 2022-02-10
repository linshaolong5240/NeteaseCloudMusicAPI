//
//  NCMArtistSubAction.swift
//  NeteaseCloudMusicAPI
//
//  Created by teenloong on 2021/6/6.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌手收藏
public struct NCMArtistSubAction: NCMAction {
    public struct ArtistSubParameters: Encodable {
        public var artistId: Int
        public var artistIds: [Int]
    }
    public typealias Parameters = ArtistSubParameters
    public typealias Response = NCMArtistSubResponse

    public var sub: Bool
    public var uri: String { "/weapi/artist/\(sub ? "sub" : "unsub")" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(id: Int, sub: Bool) {
        self.parameters = Parameters(artistId: id, artistIds: [id])
        self.sub = sub
    }
}

public struct NCMArtistSubResponse: NCMResponse {
    public var code: Int
//    public var data: Any?
    public var message: String?
}
