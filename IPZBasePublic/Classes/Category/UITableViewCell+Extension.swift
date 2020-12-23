//
//  UITableViewCell+Extension.swift
//  PSK
//
//  Created by yijie on 2018/4/11.
//  Copyright © 2018年 ipzoe. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    public static func identifier() -> String {
        return "\(type(of: self))"
    }
}

extension UITableViewHeaderFooterView {
    
    public static func identifier() -> String {
        return "\(type(of: self))"
    }
}

extension UICollectionReusableView {
    
    public static func identifier() -> String {
        return "\(type(of: self))"
    }
}


