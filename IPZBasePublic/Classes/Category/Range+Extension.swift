//
//  Range+Extension.swift
//  PSK
//
//  Created by tommy on 2018/11/2.
//  Copyright © 2018 ipzoe. All rights reserved.
//

import Foundation

extension Range where Bound == String.Index {
    
    public var nsRange: NSRange {
        return NSRange(location: self.lowerBound.encodedOffset, length: self.upperBound.encodedOffset - self.lowerBound.encodedOffset)
    }
}
