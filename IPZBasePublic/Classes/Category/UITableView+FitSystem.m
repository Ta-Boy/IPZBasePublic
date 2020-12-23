//
//  UITableView+FitSystem.m
//  easyRenting
//
//  Created by tommy on 2017/9/20.
//  Copyright © 2017年 epz. All rights reserved.
//

#import "UITableView+FitSystem.h"
#import <objc/runtime.h>

@implementation UITableView (FitSystem)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(initWithFrame:style:);
        SEL swizzledSelector = @selector(swizzleInitWithFrame:style:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (instancetype)swizzleInitWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    UITableView *tableView = [self swizzleInitWithFrame:frame style:style];
    if (tableView) {
        if ([UIDevice currentDevice].systemVersion.doubleValue > 11.0) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
    return tableView;
}

@end
