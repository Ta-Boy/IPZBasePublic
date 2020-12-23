//
//  EvaCircleProgressView.swift
//  OstrichBlockChain
//
//  Created by tommy on 2018/3/26.
//  Copyright © 2018年 ipzoe. All rights reserved.
//

import UIKit

public class EvaCircleProgressView: UIView {
    
    public var progress: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func draw(_ rect: CGRect) {
        let halfWidth = rect.size.width * 0.5
        let halfHeight = rect.size.height * 0.5
        
        let center = CGPoint.init(x: halfWidth, y: halfHeight)
        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = self.progress * CGFloat(Double.pi * 2.0) - CGFloat(Double.pi / 2.0)
        
        UIColor.init(white: 1.0, alpha: 0.1).setStroke()
        
        let backCirclePath = UIBezierPath.init(arcCenter: center, radius: halfWidth - 2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        backCirclePath.lineCapStyle = .round
        backCirclePath.lineJoinStyle = .round
        backCirclePath.lineWidth = 4
        backCirclePath.stroke()
        
        UIColor.init(white: 1.0, alpha: 0.8).setStroke()
        
        let circlePath = UIBezierPath.init(arcCenter: center, radius: halfWidth - 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circlePath.lineCapStyle = .round
        circlePath.lineJoinStyle = .round
        circlePath.lineWidth = 4
        circlePath.stroke()
    }
}
