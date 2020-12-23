//
//  UIFont+LayoutFit.swift
//  SwiftDevelopFramework
//
//  Created by tommy on 2016/10/26.
//  Copyright © 2016年 eva. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

//MARK: - 根据比例算出适配后的文字大小
    
    public static func lf_systemFont(size: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size), weight: UIFont.Weight.regular)
        } else {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size))
        }
    }
    
    public static func lf_systemUltraLightFont(size: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size), weight: UIFont.Weight.ultraLight)
        } else {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size))
        }
    }
    
    public static func lf_systemThinFont(size: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size), weight: UIFont.Weight.thin)
        } else {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size))
        }
    }
    
    public static func lf_systemLightFont(size: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size), weight: UIFont.Weight.light)
        } else {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size))
        }
    }
    
    public static func lf_systemMediumFont(size: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size), weight: UIFont.Weight.medium)
        } else {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size))
        }
    }
    
    public static func lf_systemBoldFont(size: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size), weight: UIFont.Weight.bold)
        } else {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size))
        }
    }
    
    public static func lf_systemHeavyFont(size: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size), weight: UIFont.Weight.heavy)
        } else {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size))
        }
    }
    
    public static func lf_systemBlackFont(size: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size), weight: UIFont.Weight.black)
        } else {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size))
        }
    }
    
    public static func lf_systemRegularFont(size: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size), weight: UIFont.Weight.regular)
        } else {
            return UIFont.systemFont(ofSize: UIView.lf_sizeFromIphone6(size: size))
        }
    }
}
