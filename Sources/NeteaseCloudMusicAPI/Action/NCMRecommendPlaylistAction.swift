//
//  NCMRecommendPlaylistAction.swift
//  NeteaseCloudMusicAPI
//
//  Created by teenloong on 2021/6/9.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//推荐歌单( 需要登录 )
public struct NCMRecommendPlaylistAction: NCMAction {
    public typealias Response = NCMRecommendPlaylistResponse

    public var uri: String { "/weapi/v1/discovery/recommend/resource" }
    public var responseType = Response.self
    
    public init() {
        
    }
}

public struct NCMRecommendPlaylistResponse: NCMResponse {
    public struct RecommendPlaylist: Codable, Equatable {
        public var alg, copywriter: String
        public var createTime: Int
        public var creator: NCMCrteatorResponse?
        public var id: Int
        public var name: String
        public var picUrl: String
        public var playcount, trackCount, type, userId: Int
    }
    public var code: Int
    public var featureFirst: Bool
    public var haveRcmdSongs: Bool
    public var recommend: [RecommendPlaylist]
    public var message: String?
}
