//
// Created by tommy on 2018/1/11.
// Copyright (c) 2018 ipzoe. All rights reserved.
//

import Foundation

public enum EvaSettingCellAccessoryType {
    case title
    case arrow
    case titleArrow
    case `switch`
    case imageArrow
    case image
    case leftHeaderImage
    case editText
}

public class EvaSettingCellModel: NSObject {
    
    public var title: String?
    public var subTitle: String?
    public var cellImage: UIImage?
    public var action: Selector?
    public var showingImage: UIImage?
    public var targetClass: AnyClass?
    public var cellAccessoryType: EvaSettingCellAccessoryType = .title
    public var isSwitchOn: Bool = false
    public var isSwitchDisabled: Bool = false
    public var attributedSubTitle: NSMutableAttributedString?

    public convenience init(title: String?, subTitle: String?, cellImage: UIImage?, showingImage: UIImage?, targetClass: AnyClass?, action: Selector?, isSwitchOn: Bool, type: EvaSettingCellAccessoryType) {
        self.init()
        self.title = title
        self.subTitle = subTitle
        self.cellImage = cellImage
        self.showingImage = showingImage
        self.targetClass = targetClass
        self.action = action
        self.isSwitchOn = isSwitchOn
        self.cellAccessoryType = type
    }
}
