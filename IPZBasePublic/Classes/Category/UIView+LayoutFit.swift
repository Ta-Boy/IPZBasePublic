//
//  UIView+LayoutFit.swift
//  SwiftDevelopFramework
//
//  Created by tommy on 2016/10/26.
//  Copyright © 2016年 eva. All rights reserved.
//

import Foundation
import UIKit

typealias GetScreenWidthBlock = () -> (CGFloat)

private var kCurrentShowWidth: CGFloat?
private let kTargetBaseWidth: CGFloat = 375.0

extension UIView {

    /// 依据iPhone6的尺寸得到当前屏幕相对于iPhone5屏幕尺寸的大小
    public static func lf_sizeFromIphone6(size: CGFloat) -> CGFloat {

        if let baseWidth = kCurrentShowWidth {
            return baseWidth / kTargetBaseWidth * size
        }

        var portraitWidth = (UIApplication.shared.statusBarOrientation == .landscapeRight) ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width

        if UIDevice.current.model.contains("iPad") {
            portraitWidth = 375.0
        }
        kCurrentShowWidth = portraitWidth
        return portraitWidth / kTargetBaseWidth * size
    }

    // 依据真实的尺寸得到iPhone6屏幕尺寸的大小
    public static func lf_sizeFromRealSize(size: CGFloat) -> CGFloat {

        if let baseWidth = kCurrentShowWidth {
            return kTargetBaseWidth / baseWidth * size
        }

        var portraitWidth = (UIApplication.shared.statusBarOrientation == .landscapeRight) ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
        
        if UIDevice.current.model.contains("iPad") {
            portraitWidth = 375.0
        }
        kCurrentShowWidth = portraitWidth
        return kTargetBaseWidth / portraitWidth  * size;
    }

    // 根据iPhone5的尺寸获得指定宽度相对于iPhone5屏幕尺寸的rectSize
    public static func lf_rectSizeFromIphone6(size: CGFloat) -> CGSize {
        return CGSize.init(width: UIView.lf_sizeFromIphone6(size: size), height: UIView.lf_sizeFromIphone6(size: size));
    }
}

extension CGFloat {
    public var sizeFromIphone6: CGFloat {
        return UIView.lf_sizeFromIphone6(size: self)
    }

    public var sizeFromRealSize: CGFloat {
        return UIView.lf_sizeFromRealSize(size: self)
    }

    public var rectSizeFromIphone6: CGSize {
        return UIView.lf_rectSizeFromIphone6(size: self)
    }
}

extension Float {
    public var sizeFromIphone6: CGFloat {
        CGFloat(self).sizeFromIphone6
    }

    public var sizeFromRealSize: CGFloat {
        CGFloat(self).sizeFromRealSize
    }

    public var rectSizeFromIphone6: CGSize {
        CGFloat(self).rectSizeFromIphone6
    }
}

extension Double {
    public var sizeFromIphone6: CGFloat {
        CGFloat(self).sizeFromIphone6
    }

    public var sizeFromRealSize: CGFloat {
        CGFloat(self).sizeFromRealSize
    }

    public var rectSizeFromIphone6: CGSize {
        CGFloat(self).rectSizeFromIphone6
    }
}

extension Int {
    public var sizeFromIphone6: CGFloat {
        CGFloat(self).sizeFromIphone6
    }

    public var sizeFromRealSize: CGFloat {
        CGFloat(self).sizeFromRealSize
    }

    public var rectSizeFromIphone6: CGSize {
        CGFloat(self).rectSizeFromIphone6
    }
}
