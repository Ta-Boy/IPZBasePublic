//
//  GlobalProperties.swift
//  MonoFake
//
//  Created by tommy on 2017/12/18.
//  Copyright © 2017年 TommyStudio. All rights reserved.
//

import Foundation
import UIKit

public class GlobalProperties: NSObject {

// MARK: - 常用属性

    public static let SCREEN_SIZE: CGSize = UIScreen.main.bounds.size

    public static let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width

    public static let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height

    public static let NAV_HEIGHT: CGFloat = CGFloat(64.0)

    public static let iOS8Before: Bool = ((UIDevice.current.systemVersion as NSString).floatValue < Float(8.0))

    public static let iOS8Later: Bool = ((UIDevice.current.systemVersion as NSString).floatValue >= Float(8.0))

    public static let iOS9Later: Bool = ((UIDevice.current.systemVersion as NSString).floatValue >= Float(9.0))

    public static let iOS11Later: Bool = ((UIDevice.current.systemVersion as NSString).floatValue >= Float(11.0))

    public static let iOS11Before: Bool = ((UIDevice.current.systemVersion as NSString).doubleValue < 11.0)

    public static let iPad: Bool = UIDevice.current.model.contains("iPad")

    public static let APPLICATION_VERSION: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

    public static let iPhone4: Bool = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 640.0, height: 960.0), (UIScreen.main.currentMode?.size)!) : false

    public static let iPhone5: Bool = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 640.0, height: 1136.0), (UIScreen.main.currentMode?.size)!) : false

    public static let iPhone6: Bool = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 750.0, height: 1334.0), (UIScreen.main.currentMode?.size)!) : false

    public static let iPhone6p: Bool = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1242.0, height: 2208.0), (UIScreen.main.currentMode?.size)!) : false

    public static let iPhoneXSMax: Bool = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1242.0, height: 2688.0), (UIScreen.main.currentMode?.size)!) : false)

    public static let iPhoneXR: Bool = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 828.0, height: 1792.0), (UIScreen.main.currentMode?.size)!) : false)

    public static let DocumentPath: String = (NSHomeDirectory() as NSString).appendingPathComponent("Documents")

    public static var COLOR_MAIN_1: UIColor = UIColor.color(r: 189, g: 8, b: 28)

    public static var COLOR_MAIN_2: UIColor = UIColor.color(r: 103, g: 143, b: 219)

// MARK: - 颜色定义

    public static let COLOR_B90: UIColor = UIColor.color(r: 25, g: 25, b: 25)

    public static let COLOR_B80: UIColor = UIColor.color(r: 51, g: 51, b: 51)

    public static let COLOR_B60: UIColor = UIColor.color(r: 102, g: 102, b: 102)

    public static let COLOR_B40: UIColor = UIColor.color(r: 153, g: 153, b: 153)

    public static let COLOR_B20: UIColor = UIColor.color(r: 204, g: 204, b: 204)

    public static let COLOR_LINE: UIColor = UIColor.color(r: 224, g: 224, b: 224)

    public static let COLOR_BG: UIColor = UIColor.color(r: 245, g: 245, b: 245)

// MARK: - 字体定义

    public static let FONT_SIZE_7: UIFont = UIFont.lf_systemFont(size: 20)

    public static let FONT_SIZE_6: UIFont = UIFont.lf_systemFont(size: 17)

    public static let FONT_SIZE_5: UIFont = UIFont.lf_systemFont(size: 15)

    public static let FONT_SIZE_4: UIFont = UIFont.lf_systemFont(size: 14)

    public static let FONT_SIZE_3: UIFont = UIFont.lf_systemFont(size: 13)

    public static let FONT_SIZE_2: UIFont = UIFont.lf_systemFont(size: 12)

    public static let FONT_SIZE_1: UIFont = UIFont.lf_systemFont(size: 10)

// MARK: - 颜色获取方法

    public static func colorWithRGB(red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor(red: CGFloat(Float(red) / 255.0), green: CGFloat(Float(green) / 255.0), blue: CGFloat(Float(blue) / 255.0), alpha: CGFloat(1.0))
    }

    public static func colorWithRGBA(red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(red: CGFloat(Float(red) / 255.0), green: CGFloat(Float(green) / 255.0), blue: CGFloat(Float(blue) / 255.0), alpha: CGFloat(alpha))
    }

    public static func colorMainWithAlhpa(alpha: Float) -> UIColor {
        return UIColor(red: CGFloat(Float(189) / 255.0), green: CGFloat(Float(8) / 255.0), blue: CGFloat(Float(28) / 255.0), alpha: CGFloat(alpha))
    }

    public static func randomColor() -> UIColor {
        return colorWithRGB(red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)))
    }

// MARK: - 私有属性

    fileprivate static var isFullScreen: Bool?
}

public extension GlobalProperties {

    /// isFullScreen 是否是全面屏(刘海屏 iPhone X, XR, 11, 11 pro, ...)
    static var iPhoneX: Bool {
        if let result = isFullScreen {
            return result
        }

        if #available(iOS 11, *) {
            guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                isFullScreen = false
                return false
            }

            if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                print(unwrapedWindow.safeAreaInsets)
                isFullScreen = true
                return true
            }
        }
        isFullScreen = false
        return false
    }

    /// 顶部导航的高度
    static var kNavigationBarHeight: CGFloat {
        // return UIApplication.shared.statusBarFrame.height == 44 ? 88 : 64
        return iPhoneX ? 88 : 64
    }

    /// 顶部安全区域的高度
    /// @note: 仅针对竖屏模式
    static var kTopSafeHeight: CGFloat {
        return iPhoneX ? 44 : 0
    }

    /// 底部的安全区域
    /// @note: 仅针对竖屏模式
    static var kBottomSafeHeight: CGFloat {
        // 对于仅仅有竖屏的App 直接判断 statusBarFrame.height 就行
        // return UIApplication.shared.statusBarFrame.height == 44 ? 34 : 0
        return iPhoneX ? 34 : 0
    }
}
