//
//  NCMLoginRefreshAction.swift
//  NeteaseCloudMusicAPI
//
//  Created by teenloong on 2021/6/6.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

//登陆状态
public struct NCMLoginRefreshAction: NCMAction {
    public typealias Response = NCMLoginRefreshResponse

    public var uri: String { "/weapi/login/token/refresh" }
    public var responseType = Response.self
    
    public init() {
        
    }
}

public struct NCMLoginRefreshResponse: NCMResponse {
    public var code: Int
    public var message: String?
}
