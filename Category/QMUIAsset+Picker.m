//
//  QMUIAsset+Picker.m
//  SwiftProjectTemplate
//
//  Created by tommy on 2018/12/11.
//  Copyright © 2018 ipzoe. All rights reserved.
//

#import "QMUIAsset+Picker.h"
#import <objc/runtime.h>

@implementation QMUIAsset (Picker)

- (void)setIsSelected:(BOOL)isSelected {
    //添加isSelected关联属性
    objc_setAssociatedObject(self, @"isSelected", @(isSelected), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isSelected {
    id selectedValue = objc_getAssociatedObject(self, @"isSelected");
    if (selectedValue == nil) {
        objc_setAssociatedObject(self, @"isSelected", @(NO), OBJC_ASSOCIATION_ASSIGN);
        return NO;
    } else {
        return [objc_getAssociatedObject(self, @"isSelected") boolValue];
    }
}

@end
