//
// Created by tommy on 2020/3/26.
// Copyright (c) 2020 ipzoe. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import WebKit
import Then
import QMUIKit

public class EvaCommonWebViewController: EvaBaseViewController {

//MARK: - 属性

    public var requestUrl: String?
    public var displayTitle: String?

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationItem()

        self.setupWebView()

        self.eventListen()
    }

//MARK: - 组件初始化

    func setupNavigationItem() {
        // 添加导航
        let navView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalProperties.SCREEN_WIDTH, height: (GlobalProperties.iPhoneX ? 88 : 64)))
        navView.backgroundColor = .white
        self.view.addSubview(navView)

        navView.addSubview(self.navBackButton)
        self.navBackButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.left.equalTo(navView).offset(UIView.lf_sizeFromIphone6(size: 15))
            make.bottom.equalTo(navView).offset(-(44 - UIImage.ipzbase_image(named: "nav_back")!.size.height) * 0.5)
        }

        self.navigationTitleLabel.text = self.displayTitle
        navView.addSubview(self.navigationTitleLabel)
        self.navigationTitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalTo(navView)
            make.centerY.equalTo(self.navBackButton)
        }
    }

    func setupWebView() {
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView)

        self.webView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.init(top: GlobalProperties.iPhoneX ? 88 : 64, left: 0, bottom: 0, right: 0))
        }

        // 添加加载进度
        self.view.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { (make: ConstraintMaker) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view).offset(GlobalProperties.iPhoneX ? 88 : 64)
            make.size.equalTo(CGSize.init(width: GlobalProperties.SCREEN_WIDTH, height: UIView.lf_sizeFromIphone6(size: 2)))
        }

        // 加载页面
        if self.requestUrl != nil {
            if let url = URL.init(string: self.requestUrl!) {
                self.webView.load(URLRequest.init(url: url))
            }
        }

        self.registerKVO()
    }

//MARK: - KVO注册

    func registerKVO() {
        self.webView.rx.observeWeakly(NSNumber.self, "estimatedProgress").distinctUntilChanged().takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] number in
            guard let weakSelf = self else {
                return
            }

            guard let progress = number?.floatValue else {
                return
            }

            // 更新进度
            weakSelf.progressView.setProgress(progress, animated: true)

            if progress == 1.0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(0.1 * Float(1000)))) { [weak self] in
                   guard let weakSelf = self else {
                       return
                   }

                   weakSelf.progressView.progress = 0.0
                }
            }
        }, onError: nil).disposed(by: self.disposeBag)
    }

//MARK: - 事件监听

    func eventListen() {
        self.navBackButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else {
                return
            }

            if weakSelf.webView.canGoBack {
                weakSelf.webView.goBack()
            } else {
                weakSelf.navigationController?.popViewController(animated: true)
            }
        }, onError: nil).disposed(by: self.disposeBag)
    }

//MARK: - lazy load

    let navBackButton = EvaNoHighlightedButton.init().then { button in
        button.setImage(UIImage.ipzbase_image(named: "nav_back"), for: .normal)
    }

    let closeButton = EvaNoHighlightedButton.init().then { button in
        button.setTitle("关闭", for: .normal)
        button.titleLabel?.font = UIFont.lf_systemFont(size: 16)
        button.setTitleColor(GlobalProperties.COLOR_B80, for: .normal)
    }

    let navigationTitleLabel = UILabel.init().then { label in
        label.font = UIFont.lf_systemMediumFont(size: 18)
        label.textColor = GlobalProperties.COLOR_B80
    }

    let webView = WKWebView.init(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())

    let progressView = UIProgressView.init().then { view in
        view.progressTintColor = GlobalProperties.COLOR_MAIN_1
        view.trackTintColor = UIColor.clear
        view.progress = 0.0
    }
}

extension EvaCommonWebViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame {
            if frame.isMainFrame {
                webView.load(navigationAction.request)
            }
        }
        return nil
    }
}
