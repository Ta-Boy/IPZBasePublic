//
// Created by tommy on 2018/2/27.
// Copyright (c) 2018 ipzoe. All rights reserved.
//

import Foundation
import SnapKit
import QMUIKit

protocol EvaGrowingTextViewDelegate: UITextViewDelegate {
    func updateConstraints(newHeight: CGFloat)
}

public class EvaGrowingTextView: UITextView {

//MARK: - 属性
    
    // 最大高度
    public var maxHeight: CGFloat = UIView.lf_sizeFromIphone6(size: 100)

    // 是否显示placeholder
    public var needShowPlaceHolder: Bool = false {
        didSet {
            self.placeHolderLabel.isHidden = !needShowPlaceHolder
        }
    }

    // placeholder内容
    public var placeHolderTitle: String? {
        didSet {
            if let _ = placeHolderTitle {
                self.placeHolderLabel.text = placeHolderTitle!
            }
        }
    }

    // placeHolder的字体
    public var placeHolderFont: UIFont? {
        didSet {
            if let _ = placeHolderFont {
                self.placeHolderLabel.font = placeHolderFont!
            }
        }
    }

    public var placeHolderColor: UIColor? {
        didSet {
            if let _ = placeHolderColor {
                self.placeHolderLabel.textColor = placeHolderColor!
            }
        }
    }

    // 是否需要固定placeHolder的位置
    public var needFixedPlaceHolder: Bool = false

    // 固定placeHolderLabel的顶部offset，不再以中间对齐textView
    public var fixedPlaceHolderOffset: CGFloat = 0 {
        didSet {
            self.addSubview(self.placeHolderLabel)
            
            self.placeHolderLabel.snp.remakeConstraints { (make : ConstraintMaker) in
                make.top.equalTo(self).offset(fixedPlaceHolderOffset)
                make.left.equalTo(self).offset(5)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    weak var selfDelegate: EvaGrowingTextViewDelegate?

    var currentHeight: CGFloat = 0.0
    var textViewWidth: CGFloat = 0.0

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.addSubview(self.placeHolderLabel)
        self.placeHolderLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(5)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(manualLayoutSubViews), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//MARK: - 响应者方法
    
    public override func resignFirstResponder() -> Bool {
        if (self.text!.count == 0) {
            self.makePlaceholderLabelVisable(needShow: true)
        } else {
            self.makePlaceholderLabelVisable(needShow: false)
        }
        return super.resignFirstResponder()
    }

    public override var text: String? {
        didSet {
            if self.text!.count == 0 {
                self.makePlaceholderLabelVisable(needShow: true)
            } else {
                self.makePlaceholderLabelVisable(needShow: false)
            }
        }
    }

    public func makePlaceholderLabelVisable(needShow: Bool) {
        if needShow {
            self.addSubview(self.placeHolderLabel)

            self.placeHolderLabel.snp.makeConstraints { (make : ConstraintMaker) in
                if self.needFixedPlaceHolder {
                    make.top.equalTo(self).offset(self.fixedPlaceHolderOffset)
                } else {
                    make.centerY.equalTo(self)
                }
                make.left.equalTo(self).offset(UIView.lf_sizeFromIphone6(size: 5))
            }
        } else {
            self.placeHolderLabel.removeFromSuperview()
        }
    }

    @objc public func manualLayoutSubViews() {
        if self.textViewWidth == 0 {
            self.textViewWidth = self.bounds.size.width
        }

        if self.text!.count == 0 {
            self.makePlaceholderLabelVisable(needShow: true)
        } else {
            self.makePlaceholderLabelVisable(needShow: false)
        }

        let sizeThatFits = self.sizeThatFits(CGSize.init(width: self.textViewWidth, height: self.maxHeight))
        let newHeight = sizeThatFits.height

        if newHeight <= self.maxHeight {
            self.selfDelegate?.updateConstraints(newHeight: newHeight)
        } else {
            self.selfDelegate?.updateConstraints(newHeight: self.maxHeight)
            self.scrollRectToVisible(CGRect.init(x: 0, y: newHeight - 5, width: self.textViewWidth, height: 5), animated: true)
        }

        self.currentHeight = newHeight
    }
    
//MARK: - lazy load
    
    let placeHolderLabel = UILabel.init().then { label in
        label.textColor = GlobalProperties.COLOR_B40
        label.text = ""
        label.font = UIFont.lf_systemFont(size: 14)
        label.isHidden = true
    }
}
