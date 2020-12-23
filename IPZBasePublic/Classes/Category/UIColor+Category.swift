//
//  UIColor+Category.swift
//  SwiftDevelopFramework
//
//  Created by tommy on 2016/10/26.
//  Copyright © 2016年 eva. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public static func color(r: Float, g: Float, b: Float, a: Float) -> UIColor {
        return UIColor.init(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a));
    }
    
    public static func color(r: Float, g: Float, b: Float) -> UIColor {
        return color(r: r, g: g, b: b, a: 1.0);
    }
    
    public static func color(hexValue: String, alpha: Float) -> UIColor {
        var cString:String = hexValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased();
        
        if cString.hasPrefix("0x") {
            cString = (cString as NSString).substring(from: 2);
        }
        
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1);
        }
        
        if cString.count == 3 {
            var result = ""
            //只传入了三个数字比如000，需要转换为000000
            for num in cString {
                result.append(num)
                result.append(num)
            }
            //合并数据
            cString = result
        }
        
        if cString.count != 6 {
            return UIColor.gray;
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    public static func color(hexString: String) -> UIColor {
        return color(hexValue: hexString, alpha: 1.0);
    }
}
