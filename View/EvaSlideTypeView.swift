//
// Created by tommy on 2018/3/2.
// Copyright (c) 2018 ipzoe. All rights reserved.
//

import Foundation
import SnapKit
import QMUIKit

public protocol EvaSlideTypeViewDelegate: NSObjectProtocol {
    func typeViewClickedTypeButtonAt(index: Int)
}

public class EvaSlideTypeView: UIView {
    
    private let BASE_TAG = 100

    public var leftDeltaOffset: CGFloat = 0.0
    public var rightDeltaOffset: CGFloat = 0.0

    public var buttonSideOffset: CGFloat = 0.0 {
        didSet {
            if buttonSideOffset == 0 {
                //不设置偏移量，按比例等分按钮正常显示
                if let _ = self.firstButton {
                    self.firstButton!.titleEdgeInsets = UIEdgeInsets.zero
                }

                if let _ = self.lastButton {
                    self.lastButton!.titleEdgeInsets = UIEdgeInsets.zero
                }
            } else {
                //设置偏移量，将第一个和最后一个按钮的位置便宜到距离各自屏幕边界buttonLeftOffset的距离
                let buttonWidth = self.width / CGFloat(typeTitleArray.count)
                var leftTitleMargin: CGFloat = 0.0
                var deltaOffset: CGFloat = 0.0

                if let _ = self.firstButton {
                    leftTitleMargin = (buttonWidth - self.firstButton!.titleLabel!.intrinsicContentSize.width) * 0.5
                    deltaOffset = leftTitleMargin - buttonSideOffset

                    self.leftDeltaOffset = deltaOffset

                    self.firstButton!.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -deltaOffset, bottom: 0, right: deltaOffset)

                    self.slideLine.snp.updateConstraints { (make: ConstraintMaker) in
                        make.centerX.equalTo(self.snp.left).offset((GlobalProperties.SCREEN_WIDTH / CGFloat(typeTitleArray.count * 2)) - deltaOffset)
                    }

                    self.layoutIfNeeded()
                }

                if let _ = self.lastButton {
                    leftTitleMargin = (buttonWidth - self.lastButton!.titleLabel!.intrinsicContentSize.width) * 0.5
                    deltaOffset = leftTitleMargin - buttonSideOffset

                    self.rightDeltaOffset = deltaOffset

                    self.lastButton!.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: deltaOffset, bottom: 0, right: -deltaOffset)
                }
            }
        }
    }

    //用来做偏移
    var firstButton: EvaNoHighlightedButton?
    var lastButton: EvaNoHighlightedButton?

    var lineView: UIView?

    public var typeTitleArray: [String] = []

    public weak var delegate: EvaSlideTypeViewDelegate?

    var previousButton: EvaNoHighlightedButton?

    public convenience init(typeTitleArray: [String]) {
        self.init(frame: CGRect.init(x: 0, y: 0, width: GlobalProperties.SCREEN_WIDTH, height: UIView.lf_sizeFromIphone6(size: 40)))

        assert(typeTitleArray.count > 0, "标题个数必须大于0")

        self.typeTitleArray = typeTitleArray

        self.backgroundColor = UIColor.white

        //根据titleArray布局内部按钮
        let buttonWidth = GlobalProperties.SCREEN_WIDTH / CGFloat(typeTitleArray.count)

        for index in 0..<typeTitleArray.count {
            let title = typeTitleArray[index]

            let typeButton = EvaNoHighlightedButton.init()
            typeButton.tag = index + BASE_TAG
            typeButton.setTitle(title, for: UIControl.State.normal)
            typeButton.setTitleColor(GlobalProperties.COLOR_B40, for: UIControl.State.normal)
            typeButton.setTitleColor(GlobalProperties.COLOR_B80, for: UIControl.State.selected)
            typeButton.titleLabel?.font = UIFont.lf_systemFont(size: 14)
            typeButton.addTarget(self, action: #selector(handleTypeButtonEvent(button:)), for: UIControl.Event.touchUpInside)
            self.addSubview(typeButton)

            typeButton.snp.makeConstraints { (make: ConstraintMaker) in
                make.bottom.equalTo(self)
                make.left.equalTo(self).offset(CGFloat(index) * buttonWidth)
                make.size.equalTo(CGSize.init(width: buttonWidth, height: UIView.lf_sizeFromIphone6(size: 50)))
            }

            if index == 0 {
                //设置默认选中第一项
                typeButton.isSelected = true
                self.previousButton = typeButton

                self.firstButton = typeButton
            } else if index == typeTitleArray.count - 1 {
                self.lastButton = typeButton
            }
        }

        self.addSubview(self.slideLine)
        self.slideLine.snp.makeConstraints { (make: ConstraintMaker) in
            make.bottom.equalTo(self)
            make.centerX.equalTo(self.snp.left).offset((GlobalProperties.SCREEN_WIDTH / CGFloat(typeTitleArray.count * 2)))
            make.size.equalTo(CGSize.init(width: UIView.lf_sizeFromIphone6(size: 28), height: UIView.lf_sizeFromIphone6(size: 3)))
        }

        let cutLine = UIView.init()
        cutLine.backgroundColor = GlobalProperties.COLOR_LINE
        self.addSubview(cutLine)

        cutLine.snp.makeConstraints { (make: ConstraintMaker) in
            make.left.bottom.equalTo(self)
            make.size.equalTo(CGSize.init(width: GlobalProperties.SCREEN_WIDTH, height: 0.5))
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//MARK: - 点击事件
    @objc func handleTypeButtonEvent(button: EvaNoHighlightedButton) {

        if let _ = self.previousButton {
            self.previousButton!.isSelected = false
        }

        button.isSelected = true
        self.previousButton = button

        let index: Int = button.tag - BASE_TAG

        if index == 0 {
            let position = CGFloat(2 * index + 1) * GlobalProperties.SCREEN_WIDTH / CGFloat(self.typeTitleArray.count * 2)
            self.slideLine.snp.updateConstraints { (make: ConstraintMaker) in
                make.centerX.equalTo(self.snp.left).offset(position - self.leftDeltaOffset)
            }
        } else if index == self.typeTitleArray.count - 1 {
            let position = CGFloat(2 * index + 1) * GlobalProperties.SCREEN_WIDTH / CGFloat(self.typeTitleArray.count * 2)
            self.slideLine.snp.updateConstraints { (make: ConstraintMaker) in
                make.centerX.equalTo(self.snp.left).offset(position + self.rightDeltaOffset)
            }
        } else {
            self.slideLine.snp.updateConstraints { (make: ConstraintMaker) in
                make.centerX.equalTo(self.snp.left).offset((CGFloat(2 * index + 1) * GlobalProperties.SCREEN_WIDTH / CGFloat(self.typeTitleArray.count * 2)))
            }
        }

        UIView.animate(withDuration: 0.3) { () -> Void in
            self.layoutIfNeeded()
        }

        self.delegate?.typeViewClickedTypeButtonAt(index: index)
    }
    
//MARK: - lazy load

    let slideLine = UIView.init().then { view in
        view.backgroundColor = GlobalProperties.COLOR_MAIN_1
    }
}
