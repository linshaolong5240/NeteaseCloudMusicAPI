//
//  NCMCloudUploadInfoAction.swift
//  Qin
//
//  Created by teenloong on 2021/7/12.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct NCMCloudUploadInfoAction: NCMAction {
    public struct CloudUploadInfo: Encodable {
        var album: String = "Unknown"
        var artist: String = "Unknown"
        var bitrate: String = "999000"
        var filename: String
        var md5: String
        var resourceId: Int
        var song: String
        var songid: String
        
        public init(album: String, artist: String, bitrate: String = "999000", filename: String, md5: String, resourceId: Int, songName: String, songid: String) {
            self.album = album
            self.artist = artist
            self.bitrate = bitrate
            self.filename = filename
            self.md5 = md5
            self.resourceId = resourceId
            self.song = songName
            self.songid = songid
        }
    }
    public typealias Parameters = CloudUploadInfo
    public typealias Response = NCMCloudUploadInfoResponse
    
    public var uri: String { "/weapi/upload/cloud/info/v2"}
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(info: CloudUploadInfo) {
        self.parameters = info
    }
}

public struct NCMCloudUploadInfoResponse: NCMResponse {
    public var code: Int
    public var songId: String
    public var message: String?
}
