//
// Created by tommy on 2020/2/27.
// Copyright (c) 2020 ipzoe. All rights reserved.
//

import Foundation
import SnapKit
import QMUIKit

public class EvaNoDataView: QMUIButton {

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public convenience init(imageName: String?, attributedTitle: NSAttributedString?) {
        self.init()

        if imageName != nil {
            self.setImage(UIImage.init(named: imageName!), for: UIControl.State.normal)
        }

        if attributedTitle != nil {
            self.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
        }

        if imageName != nil && attributedTitle != nil {
            // 同时存在图片和文字，则设置图片显示方向，以及标题图片间距
            self.imagePosition = .top
            self.spacingBetweenImageAndTitle = UIView.lf_sizeFromIphone6(size: 20)
        }

    }

    public static func attachTo(superView: UIView, imageName: String?, attributedTitle: NSAttributedString?,
                         topOffset: CGFloat) {
        self.clearOn(superView: superView)

        let noDataView = EvaNoDataView.init(imageName: imageName, attributedTitle: attributedTitle)
        superView.addSubview(noDataView)

        noDataView.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalTo(superView)
            make.top.equalTo(superView).offset(topOffset)
        }
    }

    public static func clearOn(superView: UIView) {
        for subView in superView.subviews {
            if subView.isKind(of: EvaNoDataView.self) {
                subView.removeFromSuperview()
            }
        }
    }
}
