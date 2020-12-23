//
//  EvaNoHighlightedButton.swift
//  MonoFake
//
//  Created by tommy on 2017/12/19.
//  Copyright © 2017年 TommyStudio. All rights reserved.
//

import UIKit
import QMUIKit

public class EvaNoHighlightedButton: QMUIButton {

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isHighlighted: Bool  {
        get {
            return super.isHighlighted
        }
        
        set {
            
        }
    }

}
