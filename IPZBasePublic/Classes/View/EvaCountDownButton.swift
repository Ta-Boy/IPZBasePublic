//
//  EvaCountDownButton.swift
//  TuyangWord
//
//  Created by tommy on 2018/1/9.
//  Copyright © 2018年 ipzoe. All rights reserved.
//

import UIKit

public class EvaCountDownButton: UIButton {

//MARK: - 定义基本数据类型
    
    private var currentSeconds = 60
    private var maxSeconds: Int = 60
    private var normalTitle: String = "获取验证码"
    private var normalColor: UIColor = UIColor.color(r: 158, g: 158, b: 158)
    private var countingFormat: String = "(%zds)"
    private var countingColor: UIColor = UIColor.color(r: 158, g: 158, b: 158)
    private var timer: Timer?
    
    public init(normalTitle: String, normalColor: UIColor, countingFormat: String, countingColor: UIColor, maxSeconds: Int) {
        super.init(frame: CGRect.zero)
        
        self.normalTitle = normalTitle
        self.normalColor = normalColor
        self.countingFormat = countingFormat
        self.countingColor = countingColor
        self.maxSeconds = maxSeconds
        self.currentSeconds = maxSeconds
        
        //设置按钮属性
        self.setTitle(normalTitle, for: UIControl.State.normal)
        self.setTitle(String(format:self.countingFormat,maxSeconds), for: UIControl.State.disabled)
        
        self.setTitleColor(normalColor, for: UIControl.State.normal)
        self.setTitleColor(countingColor, for: UIControl.State.disabled)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//MARK: - 启动倒计时
    
    public func fireCountDown() {
        if let _ = self.timer {
            self.timer!.invalidate()
            self.timer = nil
        }
        
        self.currentSeconds = self.maxSeconds
        
        self.isEnabled = false
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDownTimerEvent), userInfo: nil, repeats: true)
    }
    
    @objc private func countDownTimerEvent() {
        self.currentSeconds -= 1
        
        if self.currentSeconds == 0 {
            if let _ = self.timer {
                self.timer!.invalidate()
                self.timer = nil
            }
            
            self.currentSeconds = self.maxSeconds
            self.setTitle(String(format:self.countingFormat,self.currentSeconds), for: UIControl.State.disabled)
            
            self.isEnabled = true
        } else {
            self.setTitle(String(format:self.countingFormat,self.currentSeconds), for: UIControl.State.disabled)
        }
    }

}
