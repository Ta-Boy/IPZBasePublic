//
//  EvaHttpTool.swift
//  Mono
//
//  Created by tommy on 2016/11/4.
//  Copyright © 2016年 eva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

typealias EvaRequestFailure = (_ error: NSError) -> (Void);
typealias EvaRequestSuccess = (_ response: EvaHTTPResponse) -> (Void);

public enum EvaHttpResult {
    case success(response: EvaHTTPResponse)
    case failure(error: NSError?)
}

public class EvaHttpTool: NSObject {

//MARK: - 接口地址

    private static var BASE_URL = ""
    private static var TOKEN_KEY = ""
    private static var TOKEN_VALUE = ""
    
//MARK: - 初始化
    
    public static func initializeWithParams(baseUrl: String, tokenKey: String, tokenValue: String) {
        BASE_URL = baseUrl
        TOKEN_KEY = tokenKey
        TOKEN_VALUE = tokenValue
    }
    
    public static func clearUserLoginCache() {
        TOKEN_VALUE = ""
    }
    
    public static func get(url: String, params: [String: Any]?) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        let tokenHeader: HTTPHeaders = [TOKEN_KEY: TOKEN_VALUE]
        
        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")
        debugPrint("request param: \(String(describing: params))")

        // 执行请求
        return requestJSON(.get, URL.init(string: "\(BASE_URL)\(url)")!, parameters: params, encoding: URLEncoding.default, headers: tokenHeader)
    }

    public static func post(url: String, params: [String: Any]?) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        let tokenHeader: HTTPHeaders = [TOKEN_KEY: TOKEN_VALUE]

        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")
        debugPrint("request param: \(String(describing: params))")

        // 执行请求
        return requestJSON(.post, URL.init(string: "\(BASE_URL)\(url)")!, parameters: params, encoding: URLEncoding.default, headers: tokenHeader)
    }

    public static func postJson(url: String, params: [String: Any]?) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        var tokenHeader: HTTPHeaders = [:]
        tokenHeader["Content-Type"] = "application/json"
        tokenHeader[TOKEN_KEY] = TOKEN_VALUE

        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")
        debugPrint("request param: \(String(describing: params))")

        // 执行请求
        return requestJSON(.post, URL.init(string: "\(BASE_URL)\(url)")!, parameters: params, encoding: JSONEncoding.default, headers: tokenHeader)
    }
}
