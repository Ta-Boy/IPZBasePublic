//
//  UIView+Category.swift
//  SwiftDevelopFramework
//
//  Created by tommy on 2016/10/26.
//  Copyright © 2016年 eva. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public var x : CGFloat {
        set {
            var frame = self.frame;
            frame.origin.x = newValue;
            self.frame = frame;
        }
        
        get {
            return self.frame.origin.x;
        }
    }
    
    public var y : CGFloat {
        set {
            var frame = self.frame;
            frame.origin.y = newValue;
            self.frame = frame;
        }
    
        get {
            return self.frame.origin.y;
        }
    }
    
    public var width : CGFloat {
        set {
            var frame = self.frame;
            frame.size.width = newValue;
            self.frame = frame;
        }
        
        get {
            return self.frame.size.width;
        }
    }
    
    public var height : CGFloat {
        set {
            var frame = self.frame;
            frame.size.height = newValue
            self.frame = frame;
        }
        
        get {
            return self.frame.size.height;
        }
    }
    
    public var size : CGSize {
        set {
            var frame = self.frame;
            frame.size = newValue;
            self.frame = frame;
        }
        
        get {
            return self.frame.size;
        }
    }
    
    public var origin : CGPoint {
        set {
            var frame = self.frame;
            frame.origin = newValue;
            self.frame = frame;
        }
        
        get {
            return self.frame.origin;
        }
    }
    
    public func captureToImage() -> UIImage? {
        let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        if let contextRef = UIGraphicsGetCurrentContext() {
            self.layer.render(in: contextRef)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        } else {
            return nil
        }
    }
}
