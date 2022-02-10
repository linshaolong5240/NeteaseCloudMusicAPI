//
//  NCMCloudSongAddAction.swift
//  NeteaseCloudMusicAPI
//
//  Created by teenloong on 2021/7/12.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct NCMCloudSongAddAction: NCMAction {
    public struct CloudSongAddParameters: Encodable {
        var songid: Int
    }
    public typealias Parameters = CloudSongAddParameters
    public typealias Response = NCMCloudSongAddResponse
    public var host: String { cloudHost }
    public var uri: String { "/weapi/cloud/pub/v2"}
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(id: Int) {
        self.parameters = Parameters(songid: id)
    }
}

public struct NCMCloudSongAddResponse: NCMResponse {
    public var code: Int
    public var message: String?
}
