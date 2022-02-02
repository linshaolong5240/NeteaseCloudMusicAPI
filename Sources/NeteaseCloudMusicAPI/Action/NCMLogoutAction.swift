//
//  NCMLogoutAction.swift
//  Qin
//
//  Created by teenloong on 2021/5/28.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

//退出登录
public struct NCMLogoutAction: NCMAction {
    public typealias Response = NCMLogoutResponse

    public var uri: String { "/weapi/logout" }
    public var responseType = Response.self
    
    public init() {
        
    }
}

public struct NCMLogoutResponse: NCMResponse {
    public var code: Int
    public var message: String?
}
