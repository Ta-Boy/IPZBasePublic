//
//  MNBannerView.swift
//  MonoFake
//
//  Created by tommy on 2017/12/21.
//  Copyright © 2017年 TommyStudio. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import AVFoundation
import ObjectMapper

public protocol EvaBannerViewDelegate: NSObjectProtocol {
    func clickedBannerView(item: EvaBannerModel)
}

public class EvaBannerModel: NSObject, Mappable {

    // banner类型
    //
    // - URL: url链接类型
    enum EvaBannerType {
        case URL
        case GoodsDetail
    }

    var bannerImage: String = ""
    var bannerTitle: String = ""
    var bannerLink: String = ""
    var goodId: String?
    var testImage: UIImage?
    var bannerType: EvaBannerType = EvaBannerType.URL

    override init() {
        super.init()
    }

    required public init?(map: Map) {

    }

    public func mapping(map: Map) {
        bannerImage <- map["image"]
        bannerTitle <- map["title"]
        bannerLink <- map["link"]
        goodId <- map["goodId"]
    }
}

public class EvaBannerImageView: UIImageView {

//MARK: - 属性
    
    public var bannerItem: EvaBannerModel? {
        didSet {
            if let _ = bannerItem {
                if self.bannerItem?.testImage != nil {
                    self.image = self.bannerItem?.testImage
                } else {
                    // 设置图片显示
                    self.kf.setImage(with: URL.init(string: bannerItem!.bannerImage), placeholder: UIImage.init(named: "banner_placeholder"), options: nil, progressBlock: nil) { (image: UIImage?, error: NSError?, cacheType: CacheType, url: URL?) in
                        if image != nil {
                            //切割图片
                            let height = GlobalProperties.SCREEN_WIDTH * image!.size.height / image!.size.width
                            let resultImage = image!.scale(toSize: CGSize.init(width: GlobalProperties.SCREEN_WIDTH, height: height))!
                            self.image = resultImage
                            KingfisherManager.shared.cache.clearMemoryCache()
                        }
                    }
                }

                //设置标题
                self.titleLabel.text = bannerItem!.bannerTitle
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentMode = UIView.ContentMode.scaleAspectFill

        // 添加黑色标题背景
        let titleBgView = UIView.init()
        titleBgView.isHidden = true
        titleBgView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        self.addSubview(titleBgView)

        titleBgView.snp.makeConstraints { (make: ConstraintMaker) in
            make.left.bottom.equalTo(self)
            make.size.equalTo(CGSize.init(width: GlobalProperties.SCREEN_WIDTH, height: UIView.lf_sizeFromIphone6(size: 40)))
        }

        titleBgView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.left.equalTo(titleBgView).offset(UIView.lf_sizeFromIphone6(size: 15))
            make.centerY.equalTo(titleBgView)
            make.width.lessThanOrEqualTo(GlobalProperties.SCREEN_WIDTH - UIView.lf_sizeFromIphone6(size: 30))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

//MARK: - lazy load
    
    let titleLabel = UILabel.init().then { label in
        label.font = UIFont.lf_systemFont(size: 16)
        label.textColor = UIColor.white
        label.text = ""
    }
}

public class EvaBannerView: UIView, UIScrollViewDelegate {

    public var lastOffset: CGFloat = 0.0

    public var bannerItemArray: [EvaBannerModel] = [] {
        //设置完毕之后，更新banner显示
        didSet {
            self.pageControl.currentPage = 0

            if bannerItemArray.count == 0 {
                return
            }

            for bannerImageView in self.bannerScrollView.subviews {
                if bannerImageView.isKind(of: EvaBannerImageView.self) {
                    bannerImageView.removeFromSuperview()
                }
            }

            self.scrollTimer?.invalidate()
            self.scrollTimer = nil;

            let lastModel = Mapper<EvaBannerModel>().map(JSON: (self.bannerItemArray.last!).toJSON())
            lastModel?.testImage = self.bannerItemArray.last?.testImage

            let firstModel = Mapper<EvaBannerModel>().map(JSON: (self.bannerItemArray.first!).toJSON())
            firstModel?.testImage = self.bannerItemArray.first?.testImage

            var tempImageArray = [EvaBannerModel]()
            tempImageArray.append(lastModel!)
            tempImageArray.append(contentsOf: self.bannerItemArray)
            tempImageArray.append(firstModel!)

            for index in 0..<tempImageArray.count {
                let bannerItem = tempImageArray[index]

                let bannerImageView = EvaBannerImageView.init(frame: CGRect.init(x: CGFloat(index) * GlobalProperties.SCREEN_WIDTH, y: 0, width: GlobalProperties.SCREEN_WIDTH, height: self.height))
                bannerImageView.isUserInteractionEnabled = true
                bannerImageView.backgroundColor = UIColor.lightGray
                bannerImageView.layer.masksToBounds = true
                bannerImageView.bannerItem = bannerItem
                bannerImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleClickedBanner(recognizer:))))
                self.bannerScrollView.addSubview(bannerImageView)
            }

            if self.bannerItemArray.count > 1 {
                self.bannerScrollView.isScrollEnabled = true

                self.bannerScrollView.contentSize = CGSize.init(width: GlobalProperties.SCREEN_WIDTH * CGFloat(tempImageArray.count), height: self.height)
                self.bannerScrollView.contentOffset = CGPoint.init(x: GlobalProperties.SCREEN_WIDTH, y: 0)

                self.scrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)

                self.pageControl.isHidden = !self.showPageControl
                self.pageControl.numberOfPages = bannerItemArray.count

                self.lastOffset = GlobalProperties.SCREEN_WIDTH
            } else {
                //只有一个banner，则不再允许滑动
                self.bannerScrollView.isScrollEnabled = false

                self.scrollTimer?.invalidate()
                self.scrollTimer = nil

                self.pageControl.isHidden = self.showPageControl
                self.pageControl.numberOfPages = bannerItemArray.count
            }
        }
    }

    public var showPageControl: Bool = true {
        didSet {
            self.pageControl.isHidden = !self.showPageControl
        }
    }

    public var scrollTimer: Timer?

    public weak var delegate: EvaBannerViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        //添加scrollView
        self.bannerScrollView.delegate = self
        self.addSubview(self.bannerScrollView)
        self.bannerScrollView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(self).inset(UIEdgeInsets.zero)
        }

        //添加pageControl
        self.addSubview(self.pageControl)
        self.pageControl.snp.makeConstraints { (make: ConstraintMaker) in
            make.bottom.equalTo(self.bannerScrollView).offset(-UIView.lf_sizeFromIphone6(size: 5))
            make.centerX.equalTo(self.bannerScrollView);
            make.height.equalTo(25)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

//MARK: - Timer事件

    @objc func timerEvent() {
        if self.bannerScrollView.contentOffset.x > GlobalProperties.SCREEN_WIDTH * CGFloat(self.bannerItemArray.count + 1) {
            //滚动到第一张图片
            self.bannerScrollView.contentOffset = CGPoint.init(x: GlobalProperties.SCREEN_WIDTH, y: 0)
        } else {
            UIView.animate(withDuration: 0.6, animations: {
                let offset: CGFloat = self.bannerScrollView.contentOffset.x + GlobalProperties.SCREEN_WIDTH
                self.bannerScrollView.contentOffset = CGPoint.init(x: offset, y: 0)
            }, completion: { (finished: Bool) in
                if self.bannerScrollView.contentOffset.x == CGFloat(self.bannerItemArray.count) * GlobalProperties.SCREEN_WIDTH {
                    //滚动到最后一张图片
                    self.pageControl.currentPage = self.bannerItemArray.count - 1
                } else if self.bannerScrollView.contentOffset.x == CGFloat(self.bannerItemArray.count + 1) * GlobalProperties.SCREEN_WIDTH {
                    //滚动到第一张图片
                    self.bannerScrollView.contentOffset = CGPoint.init(x: GlobalProperties.SCREEN_WIDTH, y: 0);
                    self.pageControl.currentPage = 0;
                } else {
                    let offset: CGFloat = (self.bannerScrollView.contentOffset.x - GlobalProperties.SCREEN_WIDTH) / GlobalProperties.SCREEN_WIDTH + 0.5
                    let currentPage = Int(offset);
                    self.pageControl.currentPage = currentPage;
                }
            })
        }
    }

//MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.bannerItemArray.count == 0 || self.scrollTimer != nil {
            return;
        }

        let scrollRight = (scrollView.contentOffset.x - self.lastOffset > 0)

        if scrollRight && scrollView.contentOffset.x > CGFloat(self.bannerItemArray.count) * GlobalProperties.SCREEN_WIDTH {
            let deltaOffset = scrollView.contentOffset.x - CGFloat(self.bannerItemArray.count) * GlobalProperties.SCREEN_WIDTH

            if deltaOffset > 0.5 * GlobalProperties.SCREEN_WIDTH {
                scrollView.contentOffset = CGPoint.init(x: deltaOffset, y: 0)
            }
        } else if !scrollRight && scrollView.contentOffset.x < GlobalProperties.SCREEN_WIDTH {
            let deltaOffset = GlobalProperties.SCREEN_WIDTH - scrollView.contentOffset.x

            if deltaOffset > 0.5 * GlobalProperties.SCREEN_WIDTH {
                scrollView.contentOffset = CGPoint.init(x: CGFloat(self.bannerItemArray.count + 1) * GlobalProperties.SCREEN_WIDTH - deltaOffset, y: 0)
            }
        }

        let currentPage = Int(self.bannerScrollView.contentOffset.x / GlobalProperties.SCREEN_WIDTH - 0.5)
        self.pageControl.currentPage = currentPage

        self.lastOffset = scrollView.contentOffset.x;
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollTimer?.invalidate()
        self.scrollTimer = nil
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
    }

//MARK: - 点击事件

    @objc func handleClickedBanner(recognizer: UITapGestureRecognizer) {
        self.delegate?.clickedBannerView(item: (recognizer.view as! EvaBannerImageView).bannerItem!)
    }
    
//MARK: - lazy load
    
    let bannerScrollView = UIScrollView.init().then { scrollView in
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
    }

    let pageControl = UIPageControl.init().then { control in
        control.pageIndicatorTintColor = UIColor.init(white: 1.0, alpha: 0.4)
        control.currentPageIndicatorTintColor = GlobalProperties.COLOR_MAIN_1
    }
}
