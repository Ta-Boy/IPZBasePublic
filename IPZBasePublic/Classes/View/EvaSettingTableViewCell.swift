//
// Created by tommy on 2018/1/11.
// Copyright (c) 2018 ipzoe. All rights reserved.
//

import Foundation
import SnapKit

@objc public protocol EvaSettingTableViewCellDelegate: NSObjectProtocol {
    @objc optional func settingCellSwitchValueChange(resultValue: Bool, title: String)
    @objc optional func settingCellTextFieldValueChange(text: String?, title: String)
}

public class EvaSettingTableViewCell: UITableViewCell {

    public var settingCellModel: EvaSettingCellModel? {
        didSet {
            if let _ = settingCellModel {
                // 设置标题
                self.titleLabel.text = settingCellModel!.title

                // 设置副标题
                if settingCellModel!.subTitle != nil {
                    self.subTitleLabel.text = settingCellModel!.subTitle!
                } else if settingCellModel!.attributedSubTitle != nil {
                    self.subTitleLabel.attributedText = settingCellModel!.attributedSubTitle!
                }

                // 设置switch
                self.switchView.setOn(settingCellModel!.isSwitchOn, animated: true)
                self.switchView.isEnabled = !(settingCellModel!.isSwitchDisabled)

                // 设置主图片
                if settingCellModel!.cellImage != nil {
                    self.cellImageView.image = settingCellModel!.cellImage!
                }

                // 设置headerImage
                if settingCellModel!.showingImage != nil {
                    self.headerImageView.image = settingCellModel!.showingImage!
                } else {
                    self.headerImageView.image = self.defaultHeaderImage
                }

                self.editTextField.isHidden = true

                // 根据cell类型设置各组件的显示
                if settingCellModel!.cellAccessoryType == .title {
                    // 标题类型
                    self.arrowImageView.isHidden = true
                    self.subTitleLabel.isHidden = false
                    self.headerImageView.isHidden = true
                } else if settingCellModel!.cellAccessoryType == .arrow {
                    // 单箭头
                    self.arrowImageView.isHidden = false
                    self.subTitleLabel.isHidden = true
                    self.headerImageView.isHidden = true
                } else if settingCellModel!.cellAccessoryType == .titleArrow {
                    // 子标题加箭头
                    self.arrowImageView.isHidden = false
                    self.subTitleLabel.isHidden = false
                    self.headerImageView.isHidden = true
                } else if settingCellModel!.cellAccessoryType == .`switch` {
                    // Switch类型
                    self.arrowImageView.isHidden = true
                    self.subTitleLabel.isHidden = true
                    self.headerImageView.isHidden = true
                } else if settingCellModel!.cellAccessoryType == .imageArrow {
                    self.arrowImageView.isHidden = false
                    self.subTitleLabel.isHidden = true
                    self.headerImageView.isHidden = false
                } else if settingCellModel!.cellAccessoryType == .editText {
                    self.arrowImageView.isHidden = true
                    self.subTitleLabel.isHidden = true
                    self.headerImageView.isHidden = true
                    self.editTextField.isHidden = false

                    // 设置内容显示
                    self.editTextField.text = settingCellModel!.subTitle
                }
            }
        }
    }

    public weak var delegate: EvaSettingTableViewCellDelegate?

    public convenience init(settingCellModel: EvaSettingCellModel, reuseIdentifer: String) {
        self.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifer)

        self.settingCellModel = settingCellModel

        // 如果图片过大，进行缩放
        if let _ = settingCellModel.cellImage {
            if settingCellModel.cellImage!.size.width > UIView.lf_sizeFromIphone6(size: 20) {
                settingCellModel.cellImage = settingCellModel.cellImage!.scale(toSize: CGSize.init(width: UIView.lf_sizeFromIphone6(size: 20), height: UIView.lf_sizeFromIphone6(size: 20)))
            }
        }

        // 添加cell主图片
        self.cellImageView.image = settingCellModel.cellImage
        self.cellImageView.isHidden = (settingCellModel.cellImage == nil)
        self.contentView.addSubview(self.cellImageView)

        self.cellImageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(UIView.lf_sizeFromIphone6(size: 20))
        }

        // 添加标题
        self.titleLabel.text = settingCellModel.title
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
            if let _ = settingCellModel.cellImage {
                make.left.equalTo(self.cellImageView.snp.right).offset(UIView.lf_sizeFromIphone6(size: 15))
            } else {
                make.left.equalTo(self.contentView).offset(UIView.lf_sizeFromIphone6(size: 15))
            }
            make.centerY.equalTo(self.contentView)
            make.width.lessThanOrEqualTo(UIView.lf_sizeFromIphone6(size: 200))
        }

        // 添加副标题
        self.subTitleLabel.isHidden = true
        self.contentView.addSubview(self.subTitleLabel)
        if settingCellModel.subTitle != nil {
            self.subTitleLabel.text = settingCellModel.subTitle!
        } else if settingCellModel.attributedSubTitle != nil {
            self.subTitleLabel.attributedText = settingCellModel.attributedSubTitle!
        }

        // 添加编辑框
        self.editTextField.isHidden = true
        self.contentView.addSubview(self.editTextField)
        self.editTextField.text = settingCellModel.subTitle

        // 添加arrow
        self.arrowImageView.isHidden = true
        self.contentView.addSubview(self.arrowImageView)
        self.arrowImageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.right.equalTo(self.contentView).offset(UIView.lf_sizeFromIphone6(size: -15))
            make.centerY.equalTo(self.contentView)
        }

        self.switchView.addTarget(self, action: #selector(handleSwitchViewValueChanged(view:)), for: .valueChanged)


        // 根据cell类型设置各组件的约束
        if settingCellModel.cellAccessoryType == .title {
            // 标题类型
            self.arrowImageView.isHidden = true
            self.subTitleLabel.isHidden = false

            self.subTitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
                make.right.equalTo(self.contentView).offset(UIView.lf_sizeFromIphone6(size: -15))
                make.centerY.equalTo(self.contentView)
                make.width.lessThanOrEqualTo(UIView.lf_sizeFromIphone6(size: 200))
            }
        } else if settingCellModel.cellAccessoryType == .arrow {
            // 单箭头
            self.arrowImageView.isHidden = false
            self.subTitleLabel.isHidden = true
        } else if settingCellModel.cellAccessoryType == .titleArrow {
            // 子标题加箭头
            self.arrowImageView.isHidden = false
            self.subTitleLabel.isHidden = false

            self.subTitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
                make.right.equalTo(self.arrowImageView.snp.left).offset(UIView.lf_sizeFromIphone6(size: -10))
                make.centerY.equalTo(self.contentView)
                make.width.lessThanOrEqualTo(UIView.lf_sizeFromIphone6(size: 200))
            }
        } else if settingCellModel.cellAccessoryType == .`switch` {
            // Switch类型
            self.arrowImageView.isHidden = true
            self.subTitleLabel.isHidden = true

            self.contentView.addSubview(self.switchView)
            self.switchView.snp.makeConstraints { (make: ConstraintMaker) in
                make.right.equalTo(self.contentView).offset(UIView.lf_sizeFromIphone6(size: -15))
                make.centerY.equalTo(self.contentView)
            }
        } else if settingCellModel.cellAccessoryType == .imageArrow {
            self.arrowImageView.isHidden = false
            self.subTitleLabel.isHidden = true

            if settingCellModel.showingImage != nil {
                self.headerImageView.image = settingCellModel.showingImage!
            } else {
                self.headerImageView.image = self.defaultHeaderImage
            }

            self.contentView.addSubview(self.headerImageView)
            self.headerImageView.snp.makeConstraints { (make: ConstraintMaker) in
                make.right.equalTo(self.arrowImageView.snp.left).offset(UIView.lf_sizeFromIphone6(size: -10))
                make.centerY.equalTo(self.contentView)
            }
        } else if settingCellModel.cellAccessoryType == .image {
            self.arrowImageView.isHidden = true
            self.subTitleLabel.isHidden = true

            if settingCellModel.showingImage != nil {
                self.headerImageView.image = settingCellModel.showingImage!
            } else {
                self.headerImageView.image = self.defaultHeaderImage
            }

            self.contentView.addSubview(self.headerImageView)
            self.headerImageView.snp.makeConstraints { (make: ConstraintMaker) in
                make.right.equalTo(self.contentView).offset(UIView.lf_sizeFromIphone6(size: -15))
                make.centerY.equalTo(self.contentView)
            }
        } else if settingCellModel.cellAccessoryType == .editText {
            // 文字编辑类型
            self.arrowImageView.isHidden = true
            self.subTitleLabel.isHidden = true
            self.editTextField.isHidden = false

            self.editTextField.snp.makeConstraints { (make: ConstraintMaker) in
                make.right.equalTo(self.contentView).offset(UIView.lf_sizeFromIphone6(size: -15))
                make.centerY.equalTo(self.contentView)
                make.width.lessThanOrEqualTo(UIView.lf_sizeFromIphone6(size: 200))
            }

            _ = self.editTextField.rx.text.bind { (text) in
                if let _ = text, let title = settingCellModel.title {
                    self.delegate?.settingCellTextFieldValueChange?(text: text, title: title)
                }
            }
        }

        let lineView = UIView.init()
        lineView.backgroundColor = GlobalProperties.COLOR_LINE
        self.contentView.addSubview(lineView)

        lineView.snp.makeConstraints { (make: ConstraintMaker) in
            make.bottom.centerX.equalTo(self.contentView)
            make.size.equalTo(CGSize.init(width: GlobalProperties.SCREEN_WIDTH, height: 0.5))
        }
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//MARK: - 触发事件
    
    @objc func handleSwitchViewValueChanged(view: UISwitch) {
        if let _ = self.settingCellModel!.title {
            self.delegate?.settingCellSwitchValueChange?(resultValue: view.isOn, title: self.settingCellModel!.title!)
        }
    }
    
//MARK: - lazy load
    
    let defaultHeaderImage = (UIImage.ipzbase_image(named: "head_def")?.scale(toSize: CGSize.init(width: UIView.lf_sizeFromIphone6(size: 40), height: UIView.lf_sizeFromIphone6(size: 40))))!

    let headerImageView = UIImageView.init().then { imageView in
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
    }

    let cellImageView = UIImageView.init().then { imageView in
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
    }

    let titleLabel = UILabel.init().then { label in
        label.font = UIFont.lf_systemFont(size: 15)
        label.textColor = GlobalProperties.COLOR_B80
        label.text = "标题"
    }

    let subTitleLabel = UILabel.init().then { label in
        label.font = UIFont.lf_systemFont(size: 15)
        label.textColor = GlobalProperties.COLOR_B40
        label.text = "子标题"
    }

    let editTextField = UITextField.init().then { textField in
        textField.textAlignment = NSTextAlignment.right
        textField.textColor = GlobalProperties.COLOR_B40
        textField.font = UIFont.lf_systemFont(size: 15)
        textField.layer.masksToBounds = true
    }

    let arrowImageView = UIImageView.init().then { imageView in
        imageView.image = UIImage.ipzbase_image(named: "list_arrow")
    }

    let switchView = UISwitch.init().then { switchView in
        switchView.onTintColor = GlobalProperties.COLOR_MAIN_1
    }
}
