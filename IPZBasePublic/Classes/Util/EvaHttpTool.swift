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
    private static let SIGN_KEY = "API-SIGN"
    private static let TIME_STAMP_KEY = "API-TIMESTAMP"
    private static let DEVICE_KEY = "API-DEVICE"
    
//MARK: - 初始化
    
    public static func initializeWithParams(baseUrl: String, tokenKey: String, tokenValue: String) {
        BASE_URL = baseUrl
        TOKEN_KEY = tokenKey
        TOKEN_VALUE = tokenValue
    }
    
    public static func clearUserLoginCache() {
        TOKEN_VALUE = ""
    }
    
    static func getSign(device: String, timeStamp: UInt64) -> String {
        let salt = "ipzoe*2020"
        return EvaUtil.md5(string: "\(timeStamp)\(device)\(salt)" as NSString) as String
    }
    
    public static func get(url: String, params: [String: Any]?) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        let timeStamp = EvaUtil.getCurrentTimeStamp()
        let device = "IOS"
        
        var tokenHeader: HTTPHeaders = [TOKEN_KEY: TOKEN_VALUE]
        tokenHeader[SIGN_KEY] = getSign(device: device, timeStamp: timeStamp)
        tokenHeader[TIME_STAMP_KEY] = "\(timeStamp)"
        tokenHeader[DEVICE_KEY] = device
        
        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")
        debugPrint("request param: \(String(describing: params))")

        // 执行请求
        return requestJSON(.get, URL.init(string: "\(BASE_URL)\(url)")!, parameters: params, encoding: URLEncoding.default, headers: tokenHeader)
    }
    
    public static func delete(url: String, params: [String: Any]?) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        let timeStamp = EvaUtil.getCurrentTimeStamp()
        let device = "IOS"
        
        var tokenHeader: HTTPHeaders = [TOKEN_KEY: TOKEN_VALUE]
        tokenHeader[SIGN_KEY] = getSign(device: device, timeStamp: timeStamp)
        tokenHeader[TIME_STAMP_KEY] = "\(timeStamp)"
        tokenHeader[DEVICE_KEY] = device
        
        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")
        debugPrint("request param: \(String(describing: params))")

        // 执行请求
        return requestJSON(.delete, URL.init(string: "\(BASE_URL)\(url)")!, parameters: params, encoding: URLEncoding.default, headers: tokenHeader)
    }

    public static func post(url: String, params: [String: Any]?) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        let timeStamp = EvaUtil.getCurrentTimeStamp()
        let device = "IOS"
        
        var tokenHeader: HTTPHeaders = [TOKEN_KEY: TOKEN_VALUE]
        tokenHeader[SIGN_KEY] = getSign(device: device, timeStamp: timeStamp)
        tokenHeader[TIME_STAMP_KEY] = "\(timeStamp)"
        tokenHeader[DEVICE_KEY] = device
        
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
        let timeStamp = EvaUtil.getCurrentTimeStamp()
        let device = "IOS"

        var tokenHeader: HTTPHeaders = [:]
        tokenHeader["Content-Type"] = "application/json"
        tokenHeader[TOKEN_KEY] = TOKEN_VALUE
        tokenHeader[SIGN_KEY] = getSign(device: device, timeStamp: timeStamp)
        tokenHeader[TIME_STAMP_KEY] = "\(timeStamp)"
        tokenHeader[DEVICE_KEY] = device

        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")
        debugPrint("request param: \(String(describing: params))")

        // 执行请求
        return requestJSON(.post, URL.init(string: "\(BASE_URL)\(url)")!, parameters: params, encoding: JSONEncoding.default, headers: tokenHeader)
    }
    
    public static func patch(url: String, params: [String: Any]?) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        let timeStamp = EvaUtil.getCurrentTimeStamp()
        let device = "IOS"
        
        var tokenHeader: HTTPHeaders = [TOKEN_KEY: TOKEN_VALUE]
        tokenHeader[SIGN_KEY] = getSign(device: device, timeStamp: timeStamp)
        tokenHeader[TIME_STAMP_KEY] = "\(timeStamp)"
        tokenHeader[DEVICE_KEY] = device

        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")
        debugPrint("request param: \(String(describing: params))")

        // 执行请求
        return requestJSON(.patch, URL.init(string: "\(BASE_URL)\(url)")!, parameters: params, encoding: JSONEncoding.default, headers: tokenHeader)
    }
    
    public static func patchJson(url: String, params: [String: Any]?) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        let timeStamp = EvaUtil.getCurrentTimeStamp()
        let device = "IOS"

        var tokenHeader: HTTPHeaders = [:]
        tokenHeader["Content-Type"] = "application/json"
        tokenHeader[TOKEN_KEY] = TOKEN_VALUE
        tokenHeader[SIGN_KEY] = getSign(device: device, timeStamp: timeStamp)
        tokenHeader[TIME_STAMP_KEY] = "\(timeStamp)"
        tokenHeader[DEVICE_KEY] = device

        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")
        debugPrint("request param: \(String(describing: params))")

        // 执行请求
        return requestJSON(.patch, URL.init(string: "\(BASE_URL)\(url)")!, parameters: params, encoding: JSONEncoding.default, headers: tokenHeader)
    }
    
    public static func put(url: String, params: [String: Any]?) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        let timeStamp = EvaUtil.getCurrentTimeStamp()
        let device = "IOS"
        
        var tokenHeader: HTTPHeaders = [TOKEN_KEY: TOKEN_VALUE]
        tokenHeader[SIGN_KEY] = getSign(device: device, timeStamp: timeStamp)
        tokenHeader[TIME_STAMP_KEY] = "\(timeStamp)"
        tokenHeader[DEVICE_KEY] = device

        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")
        debugPrint("request param: \(String(describing: params))")

        // 执行请求
        return requestJSON(.put, URL.init(string: "\(BASE_URL)\(url)")!, parameters: params, encoding: JSONEncoding.default, headers: tokenHeader)
    }

    public static func putJson(url: String, params: [String: Any]?) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        let timeStamp = EvaUtil.getCurrentTimeStamp()
        let device = "IOS"

        var tokenHeader: HTTPHeaders = [:]
        tokenHeader["Content-Type"] = "application/json"
        tokenHeader[TOKEN_KEY] = TOKEN_VALUE
        tokenHeader[SIGN_KEY] = getSign(device: device, timeStamp: timeStamp)
        tokenHeader[TIME_STAMP_KEY] = "\(timeStamp)"
        tokenHeader[DEVICE_KEY] = device

        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")
        debugPrint("request param: \(String(describing: params))")

        // 执行请求
        return requestJSON(.put, URL.init(string: "\(BASE_URL)\(url)")!, parameters: params, encoding: JSONEncoding.default, headers: tokenHeader)
    }

    public static func uploadFile(data: Data, to url: String, fileName: String) -> Observable<(HTTPURLResponse, Any)> {
        // 设置超时时间
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 60

        // 构建header
        let timeStamp = EvaUtil.getCurrentTimeStamp()
        let device = "IOS"
        
        var tokenHeader: HTTPHeaders = [:]
        tokenHeader["Content-Type"] = "multipart/form-data"
        tokenHeader[TOKEN_KEY] = TOKEN_VALUE
        tokenHeader[SIGN_KEY] = getSign(device: device, timeStamp: timeStamp)
        tokenHeader[TIME_STAMP_KEY] = "\(timeStamp)"
        tokenHeader[DEVICE_KEY] = device

        // 打印请求参数
        debugPrint("request url: \(BASE_URL)\(url)")

        return upload(multipartFormData: { (formData: MultipartFormData) in
            formData.append(data, withName: "file", fileName: fileName)
        }, to: URL.init(string: "\(BASE_URL)\(url)")!, method: .post, headers: tokenHeader).flatMap {(request: UploadRequest) -> Observable<(HTTPURLResponse, Any)> in
            return request.rx.responseJSON()
        }
    }
}
