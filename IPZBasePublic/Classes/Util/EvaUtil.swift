//
//  EvaUtil.swift
//  SwiftDevelopFramework
//
//  Created by tommy on 2016/10/19.
//  Copyright © 2016年 eva. All rights reserved.
//

import UIKit
import AVFoundation
import CommonCrypto

public class EvaUtil: NSObject {
    
//MARK: - GCD常用闭包

    public static func runInGlobalQueue(callback : @escaping () -> ()) {
        DispatchQueue.global().async(execute: callback);
    }
    
    public static func runInMainQueue(callback : @escaping () -> ()){
        DispatchQueue.main.async(execute: callback);
    }
    
    public static func runAfterSeconds (seconds : Float, callback : @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(seconds * Float(1000)))) {
            callback();
        }
    }

//MARK:生成当前的时间戳

    public static func getCurrentTimeStamp() -> UInt64 {
        return UInt64(NSDate.init().timeIntervalSince1970 * 1000);
    }

//MARK:获取用户的的年龄

    public static func getUserAge(dateString : String, dateFormat : String) -> Int {
        let value = Double(60 * 60 * 24)
        let dateFormatter = DateFormatter.init();
        dateFormatter.dateFormat = dateFormat;
        
        if let inputDate = dateFormatter.date(from: dateString) {
            let dateDiff = inputDate.timeIntervalSinceNow;
            return Int(-trunc(dateDiff / value) / Double(365));
        }else{
            return 0;
        }
    }
    
//MARK: - 缓存清理相关

    public static func getFolderSize(path : String) -> Float {
        let fileManager = FileManager.default;
        var folderSize : Float = 0;
        if fileManager.fileExists(atPath: path) {
            
            if let childrenFiles = fileManager.subpaths(atPath: path) {
                for fileName in childrenFiles {
                    let absolutePath = (fileName as NSString).appending(fileName)
                    folderSize += getFileSize(path: absolutePath);
                }
            }
            return folderSize;
        } else {
            return 0;
        }
    }

    public static func getFileSize(path : String) -> Float {
        let fileManager = FileManager.default;
        
        if fileManager.fileExists(atPath: path) {
            do {
                let fileAttributes = try fileManager.attributesOfItem(atPath: path);
                return fileAttributes[FileAttributeKey.init("NSFileSize")] as! Float;
            } catch {
                return 0;
            }
            
        } else {
            return 0;
        }
    }
    
//MARK:  - 加密相关

   public static func uuid() -> NSString {
        let chars = "abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        assert(chars.count == 62);
        
        let length = chars.count;
        
        let resultString = NSMutableString.init();
        
        for _ in 0..<24 {
            let p = arc4random_uniform(UInt32(length));
            let range = NSMakeRange(Int(p), 1);
            resultString.append((chars as NSString).substring(with: range));
        }
        
        return resultString as NSString;
    }
    
    public static func md5(string: NSString) -> NSString {
        let cStr = (string as NSString).cString(using: String.Encoding.utf8.rawValue);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        
        free(buffer)
        
        return md5String as NSString;
    }
    
//MARK: - 检查字符串是否为数字

   public static func checkStringIsNum(string : NSString) -> Bool {
        do {
            let numberExpression = try NSRegularExpression.init(pattern: "^[0-9]*$", options: NSRegularExpression.Options.caseInsensitive);
            
            let checkResult = numberExpression.rangeOfFirstMatch(in: (string as String), options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, string.length));
            
            if checkResult.location != NSNotFound {
                return true;
            } else {
                return false;
            }
        } catch {
            return false;
        }
    }
    
//MARK: - 获取当前控制器

    public static func getShowingController() -> UIViewController? {
        var result : UIViewController?;
        
        var window : UIWindow? = UIApplication.shared.keyWindow;
        
        guard window != nil else {
            return result;
        }
        
        if window!.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows;
            
            for tempWin in windows {
                if(tempWin.windowLevel == UIWindow.Level.normal){
                    window = tempWin;
                    break;
                }
            }
        }
        
        let frontView = window!.subviews[0];
        if let nextResponder = frontView.next {
            if nextResponder.isKind(of: UIViewController.classForCoder()) {
                result = nextResponder as? UIViewController;
            } else {
                result = window!.rootViewController;
            }
        }
        
        return result;
    }
    
//MARK: - 获取当前展示控制器

    public static func getCurrentViewController() -> UIViewController? {
        var window = self.getCurrentWindow()
        if let _ = window {
            if window!.windowLevel != UIWindow.Level.normal {
                for tmpWindow in UIApplication.shared.windows {
                    if tmpWindow.windowLevel == UIWindow.Level.normal {
                        window = tmpWindow
                        break;
                    }
                }
            }
        }
        
        var result = window?.rootViewController
        
        if let _ = result {
            if result!.presentedViewController != nil {
                result = result?.presentedViewController
            }
            
            if result!.isKind(of: UITabBarController.self) {
                result = (result as! UITabBarController).selectedViewController
            }
            
            if result!.isKind(of: UINavigationController.self) {
                result = (result as! UINavigationController).topViewController
            }
        }
        
        return result
    }
    
    public static func getPresentRootViewController() -> UIViewController? {
        if var topRootViewController = self.getCurrentWindow()?.rootViewController {
            while topRootViewController.presentedViewController != nil {
                topRootViewController = topRootViewController.presentedViewController!
            }
            return topRootViewController
        } else {
            return nil
        }
    }
    
//MARK: - 日志方法
    
    public static func log(format:NSString,items: Any...) {
        let string = NSString.init(format: format, items);
        print(string);
    }
    
//MARK: - 获取当前window
    
    public static func getCurrentWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
}
