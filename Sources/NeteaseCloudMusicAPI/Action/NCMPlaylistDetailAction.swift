//
//  NCMPlaylistDetailAction.swift
//  NeteaseCloudMusicAPI
//
//  Created by teenloong on 2021/6/8.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌单详情
//说明 : 歌单能看到歌单名字, 但看不到具体歌单内容 , 调用此接口 , 传入歌单 id, 可 以获取对应歌单内的所有的音乐(未登录状态只能获取不完整的歌单,登录后是完整的)，但是返回的trackIds是完整的，tracks 则是不完整的，可拿全部 trackIds 请求一次 song/detail 接口获取所有歌曲的详情
public struct NCMPlaylistDetailAction: NCMAction {
    public struct PlaylistDetailParameters: Encodable {
        public var id: Int
        public var n: Int = 100000
        public var s: Int = 8  //歌单最近的 s 个收藏者,默认为8
    }
    public typealias Parameters = PlaylistDetailParameters
    public typealias Response = NCMPlaylistDetailResponse

    public var uri: String { "/weapi/v3/playlist/detail" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(id: Int) {
        self.parameters = Parameters(id: id)
    }
}

public struct NCMPlaylistDetailResponse: NCMResponse {
    public var code: Int
    public var playlist: NCMPlaylistResponse
    public var privileges: [NCMPrivilegeResponse]
//    public var relatedVideos: Any?
//    public var sharedPrivilege: Any?
//    public var urls: Any?
    public var message: String?
}
