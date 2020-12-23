//
//  EvaAskBaseViewController.swift
//  PSK
//
//  Created by tommy on 2018/5/25.
//  Copyright © 2018年 ipzoe. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SnapKit
import RxSwift
import RxCocoa
import QMUIKit

open class EvaAskBaseViewController: ASDKViewController<ASDisplayNode> {

    public var disposeBag = DisposeBag.init()

    public override init() {
        // 初始化
        let node = ASDisplayNode.init()
        node.backgroundColor = GlobalProperties.COLOR_BG

        super.init(node: node)
    }

//MARK: - 生命周期方法
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        //设置背景色
        self.node.view.backgroundColor = GlobalProperties.COLOR_BG

        self.whiteNavigationBarSetting()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self)) destroy")
    }

//MARK: - 导航栏设置
    
    public func normalNavigationBarSetting() {
        let titleAttr = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.lf_systemMediumFont(size: 18)]
        navigationController?.navigationBar.titleTextAttributes = titleAttr

        let item = UIBarButtonItem.appearance()
        item.tintColor = UIColor.white

        let itemAttr = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.lf_systemMediumFont(size: 16)]
        item.setTitleTextAttributes(itemAttr, for: .normal)

        navigationController?.navigationBar.setBackgroundImage(UIImage.getImage(color: GlobalProperties.COLOR_MAIN_1, size: CGSize.init(width: CGFloat(1), height: CGFloat(1)), cornerRadius: 0), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage.init()
        navigationController?.navigationBar.tintColor = UIColor.white;

        if self.navigationController != nil {
            let line = UIView.init()
            line.isHidden = true
            line.backgroundColor = GlobalProperties.COLOR_LINE
            navigationController!.navigationBar.addSubview(line)

            line.snp.makeConstraints { (make: ConstraintMaker) in
                make.left.bottom.equalTo(navigationController!.navigationBar)
                make.size.equalTo(CGSize.init(width: GlobalProperties.SCREEN_WIDTH, height: 0.5))
            }
        }
    }

    public func whiteNavigationBarSetting() {
        let titleAttr = [NSAttributedString.Key.foregroundColor: GlobalProperties.COLOR_B80, NSAttributedString.Key.font: UIFont.lf_systemMediumFont(size: 18)]
        navigationController?.navigationBar.titleTextAttributes = titleAttr

        let item = UIBarButtonItem.appearance()
        item.tintColor = GlobalProperties.COLOR_B80

        let itemAttr = [NSAttributedString.Key.foregroundColor: GlobalProperties.COLOR_B80, NSAttributedString.Key.font: UIFont.lf_systemMediumFont(size: 16)]
        item.setTitleTextAttributes(itemAttr, for: .normal)

        navigationController?.navigationBar.setBackgroundImage(UIImage.getImage(color: UIColor.white, size: CGSize.init(width: CGFloat(1), height: CGFloat(1)), cornerRadius: 0), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage.init()
        navigationController?.navigationBar.tintColor = UIColor.white;

        if self.navigationController != nil {
            let line = UIView.init()
            line.isHidden = true
            line.backgroundColor = GlobalProperties.COLOR_LINE
            navigationController!.navigationBar.addSubview(line)

            line.snp.makeConstraints { (make: ConstraintMaker) in
                make.left.bottom.equalTo(navigationController!.navigationBar)
                make.size.equalTo(CGSize.init(width: GlobalProperties.SCREEN_WIDTH, height: 0.5))
            }
        }
    }

    public func setupMainNavBack() {
        let arrowImage = UIImage.ipzbase_image(named: "nav_back")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        let backButton = UIButton.init()
        backButton.setImage(arrowImage, for: .normal)
        backButton.addTarget(self, action: #selector(handleNavBack), for: UIControl.Event.touchUpInside)

        if GlobalProperties.iOS11Later {
            backButton.frame = CGRect.init(x: CGFloat(0), y: CGFloat(0), width: backButton.intrinsicContentSize.width, height: backButton.intrinsicContentSize.height)

            let leftItem = UIBarButtonItem.init(customView: backButton)
            navigationItem.leftBarButtonItem = leftItem
        } else {
            backButton.frame = CGRect.init(x: CGFloat(0), y: CGFloat(0), width: backButton.intrinsicContentSize.width, height: backButton.intrinsicContentSize.height)

            let leftItem = UIBarButtonItem.init(customView: backButton)
            let leftNegativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            leftNegativeSpacer.width = -5
            navigationItem.leftBarButtonItems = [leftNegativeSpacer, leftItem]
        }
    }

    @objc open func handleNavBack() {
        navigationController?.popViewController(animated: true)
    }

    public override func forceEnableInteractivePopGestureRecognizer() -> Bool {
        return true
    }

    public override func viewDidLayoutSubviews() {
        if self.navigationController != nil {
            self.clearImageView(view: self.navigationController!.navigationBar)
        }
    }

    public func clearImageView(view: UIView) {
        for imageView in view.subviews {
            if imageView.isKind(of: UIImageView.self) && imageView.height < 5 {
                imageView.isHidden = true
            }
            self.clearImageView(view: imageView)
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
}
