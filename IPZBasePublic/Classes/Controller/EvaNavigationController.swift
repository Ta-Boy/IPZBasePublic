//
//  EvaNavigationController.swift
//  MonoFake
//
//  Created by tommy on 2017/12/18.
//  Copyright © 2017年 TommyStudio. All rights reserved.
//

import UIKit

public class EvaNavigationController: UINavigationController {

    // 控制隐藏tabBar
    public var noNeedHideBottomTabBar: Bool! = false

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.delegate = self
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = !self.noNeedHideBottomTabBar
        }

        self.noNeedHideBottomTabBar = false

        super.pushViewController(viewController, animated: animated)
    }

    public func setupNavBarShadow(needHide: Bool) {
        if needHide {
            self.navigationBar.layer.shadowOpacity = 0.0;
        } else {
            self.navigationBar.layer.shadowOpacity = 1.0;
        }
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }

    public override var shouldAutorotate: Bool {
        return false
    }

//MARK: - UIGestureRecognizerDelegate
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = self.interactivePopGestureRecognizer, let _ = self.visibleViewController {
            if gestureRecognizer == self.interactivePopGestureRecognizer! {
                // 开始滑动返回,取消当前页面的编辑状态
                // FIXME: - 这里会报警 `[AXRuntimeCommon] AX Lookup problem - errorCode:1100 error:Permission denied portName:'com.apple.iphone.axserver' PID:8361`; 可以使用 topVC 调用方法改写(推测同样会报错)
                self.view.endEditing(true)

                if self.viewControllers.count < 2 || self.visibleViewController! == self.viewControllers[0] {
                    return false
                }
            }
        }
        return true
    }
}
