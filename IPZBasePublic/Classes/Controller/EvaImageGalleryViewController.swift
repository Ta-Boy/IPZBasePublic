//
//  EvaImageGalleryViewController.swift
//  OstrichBlockChain
//
//  Created by tommy on 2018/3/26.
//  Copyright © 2018年 ipzoe. All rights reserved.
//

import UIKit
import SnapKit
import QMUIKit

public class EvaImageGalleryViewController: UIViewController, UIScrollViewDelegate {

//MARK: - 属性
    
    private let BASE_IMAGE_TAG = 100
    
    public var galleryScrollView: UIScrollView?
    public var imageOffset: CGFloat = 0.0;
    public var lastIndex: Int = 0;
    public var scrollIndex: Int = 0;
    public var selectedIndex: Int = 0
    public var imageArray: [String] = []
    public var needAnimateCornerRadius: Bool = false
    public var animateCornerRadius: CGFloat = 0.0
    public var cellImageViewFrame: CGRect = CGRect.zero
    public var trainsitionImage: UIImage?

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black

        self.imageOffset = UIView.lf_sizeFromIphone6(size: 15)

        let galleryScrollView = UIScrollView.init(frame: CGRect.init(x: -self.imageOffset, y: 0, width: GlobalProperties.SCREEN_WIDTH + self.imageOffset, height: GlobalProperties.SCREEN_HEIGHT))
        galleryScrollView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleScrollViewTap)))
        galleryScrollView.delegate = self
        galleryScrollView.isPagingEnabled = true
        galleryScrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(galleryScrollView)
        self.galleryScrollView = galleryScrollView

        galleryScrollView.contentSize = CGSize.init(width: CGFloat(self.imageArray.count) * (GlobalProperties.SCREEN_WIDTH + imageOffset), height: 0)
        galleryScrollView.contentOffset = CGPoint.init(x: CGFloat(self.selectedIndex) * (GlobalProperties.SCREEN_WIDTH + imageOffset), y: 0)

        self.scrollIndex = self.selectedIndex
        self.lastIndex = self.selectedIndex

        if self.selectedIndex == 0 {
            for i in 0..<(((self.imageArray.count > 2) ? (self.selectedIndex + 2) : self.imageArray.count)) {
                if let _ = self.galleryScrollView?.viewWithTag(BASE_IMAGE_TAG + i) {
                    continue
                }
                self.createGalleryImageAt(index: i)
            }
        } else if self.selectedIndex == self.imageArray.count - 1 {
            let startIndex = self.selectedIndex - ((self.imageArray.count > 2) ? 2 : 1)
            for i in startIndex..<self.imageArray.count {
                self.createGalleryImageAt(index: i)
            }
        } else {
            let startIndex = self.selectedIndex - 1
            for i in startIndex..<(((self.imageArray.count > 2) ? (self.selectedIndex + 2) : self.imageArray.count)) {
                self.createGalleryImageAt(index: i)
            }
        }

        self.pageLabel.text = "\(self.selectedIndex + 1) / \(self.imageArray.count)"
        self.view.addSubview(self.pageLabel)
        self.pageLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.bottom.equalTo(self.view).offset(-UIView.lf_sizeFromIphone6(size: 20))
            make.centerX.equalTo(self.view)
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for index in 0..<self.galleryScrollView!.subviews.count {
            if let displayView = self.galleryScrollView!.subviews[index] as? EvaScaledImageDetailView {
                if displayView.animateImageView.animatedImage == nil {
                    displayView.loadDisplayGif()
                }
                displayView.animateImageView.startAnimating()
            }
        }
    }

//MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / (GlobalProperties.SCREEN_WIDTH + self.imageOffset) + 0.5)
        self.pageLabel.text = "\(page + 1) / \(self.imageArray.count)"

        self.scrollIndex = page

        if page > self.lastIndex {
            //向右滑动
            //1.创建page + 1位置的imageView
            self.createGalleryImageAt(index: page + 1)
            //2.移除lastIndex - 1位置的imageView
            if self.lastIndex != 0 {
                self.removeGalleryImageAt(index: self.lastIndex - 1)
            }
            //重置scale
            self.resetGalleryImageScaleAt(index: self.lastIndex)
            //充值lastIndex
            self.lastIndex = page
        } else if page < self.lastIndex {
            //向左滑动
            //1.创建page - 1位置的imageView
            if page != 0 {
                self.createGalleryImageAt(index: page - 1)
            }
            //2.移除page + 1位置的imageView
            self.removeGalleryImageAt(index: self.lastIndex + 1)
            //3.重置scale
            self.resetGalleryImageScaleAt(index: self.lastIndex)
            //4.重置lastIndex
            self.lastIndex = page
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        for index in 0..<self.galleryScrollView!.subviews.count {
            if let displayView = self.galleryScrollView!.subviews[index] as? EvaScaledImageDetailView {
                displayView.animateImageView.stopAnimating()
            }
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        for index in 0..<self.galleryScrollView!.subviews.count {
            if let displayView = self.galleryScrollView!.subviews[index] as? EvaScaledImageDetailView {
                if displayView.animateImageView.animatedImage == nil {
                    displayView.loadDisplayGif()
                }
                displayView.animateImageView.startAnimating()
            }
        }
    }

//MARK: - 创建和移除图片
    
    public func createGalleryImageAt(index: Int) {
        if index >= self.imageArray.count {
            return;
        }

        if let _ = self.galleryScrollView?.viewWithTag(BASE_IMAGE_TAG + index) {
            return
        }

        let imageDisplayView = EvaScaledImageDetailView.init(frame: CGRect.init(x: self.imageOffset + CGFloat(index) * (GlobalProperties.SCREEN_WIDTH + self.imageOffset), y: 0, width: GlobalProperties.SCREEN_WIDTH, height: GlobalProperties.SCREEN_HEIGHT))
        imageDisplayView.tag = BASE_IMAGE_TAG + index
        imageDisplayView.imageUrl = self.imageArray[index]
        self.galleryScrollView?.addSubview(imageDisplayView)
    }

    public func resetGalleryImageScaleAt(index: Int) {
        if index < 0 || index >= self.imageArray.count {
            return
        }

        if let imageDisplayView = self.galleryScrollView?.viewWithTag(BASE_IMAGE_TAG + index) as? EvaScaledImageDetailView {
            imageDisplayView.resetZoomScale()
        }
    }

    public func removeGalleryImageAt(index: Int) {
        if index < 0 || index >= self.imageArray.count {
            return
        }

        if let imageDisplayView = self.galleryScrollView?.viewWithTag(BASE_IMAGE_TAG + index) as? EvaScaledImageDetailView {
            imageDisplayView.removeFromSuperview()
        }
    }



//MARK: - 单击事件
    
    @objc public func handleScrollViewTap() {
        self.dismiss(animated: true, completion: nil)
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    public override var shouldAutorotate: Bool {
        return false
    }
    
//MARK: - lazy load
    
    public let pageLabel = UILabel.init().then { label in
        label.font = UIFont.lf_systemFont(size: 13)
        label.textColor = UIColor.white
        label.text = "0 / 0"
    }
}
