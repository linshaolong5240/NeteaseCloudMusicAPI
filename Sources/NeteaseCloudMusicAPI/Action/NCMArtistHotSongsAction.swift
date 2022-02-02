//
//  NCMArtistHotSongsAction.swift
//  Qin
//
//  Created by teenloong on 2021/6/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌手热门歌曲
public struct NCMArtistHotSongsAction: NCMAction {
    public typealias Response = NCMArtistHotSongsResponse

    public let id: Int
    public var uri: String { "/weapi/artist/\(id)" }
    public let responseType = Response.self
    
    public init(id: Int) {
        self.id = id
    }
}

public struct NCMArtistHotSongsResponse: NCMResponse {
    public struct HotSong: Codable {
        public struct Quality: Codable {
            public var bitrate: Int
            public var dfsId: Int
            public var `extension`: String
            public var id: Int
            public var name: String?
            public var playTime: Int
            public var size: Int
            public var sr: Int
            public var volumeDelta: Double
        }
        public var album: NCMAlbumResponse
        public var alias: [String]
        public var artists: [NCMArtistResponse]
//        public var audition: Any?
        public var bMusic: Quality?
        public var copyFrom: String
        public var copyrightId: Int
//        public var crbt: Any?
        public var dayPlays: Int
        public var disc: String
        public var duration: Int
        public var fee: Int
        public var ftype: Int
        public var hearTime: Int
        public var hMusic: Quality?
        public var id: Int
        public var lMusic: Quality?
        public var mark: Int
        public var mMusic: Quality?
        public var mp3Url: String
        public var mvid: Int
        public var name: String
        public var no: Int
//        public var noCopyrightRcmd: Any?
        public var originCoverType: Int
//        public var originSongSimpleData: Any?
        public var playedNum: Int
        public var popularity:Int
//        public var ringtone: Any?
//        public var rtUrl: Any?
//        public var rtUrls: Any?
        public var rtype:Int
//        public var rurl: Any?
        public var score: Int
        public var starred: Bool
        public var starredNum: Int
        public var status: Int
    }
    public var artist: NCMArtistResponse
    public var code: Int
    public var hotSongs: [HotSong]
    public var more: Bool
    public var message: String?
}
