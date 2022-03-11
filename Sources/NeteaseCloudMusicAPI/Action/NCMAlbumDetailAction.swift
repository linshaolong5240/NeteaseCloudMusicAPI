//
//  NCMAlbumDetailAction.swift
//  NeteaseCloudMusicAPI
//
//  Created by teenloong on 2021/6/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//专辑内容
public struct NCMAlbumDetailAction: NCMAction {
    public typealias Response = NCMAlbumDetailResponse
    
    public var id: Int
    public var uri: String { "/weapi/v1/album/\(id)"}
    public var responseType = Response.self
    
    public init (id: Int) {
        self.id = id
    }
}

public struct NCMAlbumDetailResponse: NCMResponse {

    public struct AlbumSong: Codable, Equatable {
        public struct Album: Codable, Equatable {
            public var id: Int
            public var name: String
            public var pic: Int
            public var pic_str: String
        }
        public struct AlbumSongArtist: Codable, Equatable {
            public var id: Int
            public var name: String
        }
        public struct Quality: Codable, Equatable {
            var br: Int
            var fid: Int
            var size: Int
            var vd: Double
        }
//        public var a: Any?
        public var al: Album
        public var alia: [String]
        public var ar: [AlbumSongArtist]
        public var cd: String
        public var cf: String
        public var cp: Int
//        public var crbt: Any?
        public var djId: Int
        public var dt: Int
        public var fee: Int
        public var ftype: Int
        public var h: Quality?
        public var id: Int
        public var l: Quality?
        public var m: Quality?

        public var mst: Int
        public var mv: Int
        public var name: String
        public var no: Int
//        public var noCopyrightRcmd: Any?
        public var pop: Int
        public var privilege: NCMPrivilegeResponse
        public var pst: Int
        public var rt: String?
        public var rtUrl: String?
        public var rtUrls: [String]
        public var rtype: Int
        public var rurl: String?
        public var st: Int
        public var t: Int
        public var v: Int
    }
    public var album: NCMAlbumResponse
    public var code: Int
    public var resourceState: Bool
    public var songs: [AlbumSong]
    public var message: String?
}
