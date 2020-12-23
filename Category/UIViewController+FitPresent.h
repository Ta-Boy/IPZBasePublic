//
//  UIViewController+FitPresent.h
//  ShrareLife
//
//  Created by tommy on 2019/9/23.
//  Copyright © 2019  Jelen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FitPresent)

/**
Whether or not to set ModelPresentationStyle automatically for instance, Default is [Class LL_automaticallySetModalPresentationStyle].

@return BOOL
*/
@property (nonatomic, assign) BOOL LL_automaticallySetModalPresentationStyle;

/**
 Whether or not to set ModelPresentationStyle automatically, Default is YES, but UIImagePickerController/UIAlertController is NO.

 @return BOOL
 */
+ (BOOL)LL_automaticallySetModalPresentationStyle;

@end

NS_ASSUME_NONNULL_END
