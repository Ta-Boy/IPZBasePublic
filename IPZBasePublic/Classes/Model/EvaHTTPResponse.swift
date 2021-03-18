//
//  MNHTTPResponse.swift
//  Mono
//
//  Created by tommy on 2016/11/4.
//  Copyright © 2016年 eva. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

public class EvaHTTPResponse: NSObject, Mappable {
    
    public var data: Any?
    public var code: Int = 0
    public var message: String?
    public var errorMessage: String {
        get {
            return message ?? "网络连接失败，请重试"
        }
    }

    public init(jsonData: Any) {
        super.init();

        let json = JSON.init(jsonData)
        code = json["code"].intValue
        message = json["msg"].string
        data = json["data"]
    }

    override init() {
        super.init()
    }

    required public init?(map: Map) {

    }

    public func mapping(map: Map) {
        code <- map["code"]
        message <- map["msg"]
        data <- map["data"]
    }
}
