//
//  EvaScaledImageDetailView.swift
//  OstrichBlockChain
//
//  Created by tommy on 2018/3/26.
//  Copyright © 2018年 ipzoe. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import FLAnimatedImage

public class EvaScaledImageDetailView: UIScrollView {

//MARK: - 属性

    public var isScaled: Bool = false
    public var useRealImageSize: Bool = false
    public var realImageSize: CGSize = .zero {
        didSet {
            var resultSize = self.realImageSize
            if self.realImageSize.width < self.width {
                // 按屏幕宽度缩放
                resultSize = CGSize.init(width: self.width, height: self.realImageSize.height * self.width / self.realImageSize.width)
            }

            self.contentImageView.frame = CGRect.init(x: 0, y: 0, width: resultSize.width, height: resultSize.height)
            self.contentSize = resultSize

            if (resultSize.width / resultSize.height) > (self.width / self.height) {
                // 图片宽高比大于容器宽高比
                self.contentOffset = CGPoint.init(x: (resultSize.width - self.width) * 0.5, y: 0)
            } else {
                // 图片宽高比小于容器宽高比
                self.contentOffset = CGPoint.init(x: 0, y: (resultSize.height - self.height) * 0.5)
            }
        }
    }

    public var imageUrl: String? {
        didSet {
            if let _ = imageUrl {
                guard let _ = self.imageUrl else {
                    return
                }

                // 加载网络图片
                DispatchQueue.global().async { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    if let diskImage = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: weakSelf.imageUrl!, options: [.backgroundDecode]) {
                        DispatchQueue.main.async { [weak self] in
                            guard let weakSelf = self else {
                                return
                            }

                            weakSelf.circleProgressView.isHidden = true
                            weakSelf.contentImageView.image = diskImage
                        }
                    } else {
                        if weakSelf.imageUrl!.hasSuffix(".gif") {
                            DispatchQueue.main.async { [weak self] in
                                guard let weakSelf = self else {
                                    return
                                }

                                weakSelf.circleProgressView.isHidden = false
                                weakSelf.animateImageView.isHidden = false
                                weakSelf.contentImageView.isHidden = true
                            }
                        } else {
                            DispatchQueue.main.async { [weak self] in
                                guard let weakSelf = self else {
                                    return
                                }

                                weakSelf.circleProgressView.isHidden = false
                                weakSelf.animateImageView.isHidden = true
                                weakSelf.contentImageView.isHidden = false
                            }

                            weakSelf.contentImageView.kf.setImage(with: URL.init(string: weakSelf.imageUrl!), placeholder: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
                                let progress = CGFloat(receivedSize) * 1.0 / CGFloat(totalSize)
                                DispatchQueue.main.async { [weak self] in
                                    guard let weakSelf = self else {
                                        return
                                    }

                                    weakSelf.circleProgressView.progress = progress
                                }
                            }, completionHandler: { [weak self] (image, error, cacheType, imageURL) in
                                guard let weakSelf = self else {
                                    return
                                }

                                if (image != nil) {
                                    weakSelf.circleProgressView.isHidden = true
                                    weakSelf.fitLongPicDisplay(displayImage: image!)
                                    weakSelf.contentImageView.image = image

                                    // 清理缓存
                                    KingfisherManager.shared.cache.clearMemoryCache()
                                    KingfisherManager.shared.cache.store(image!, forKey: weakSelf.imageUrl!, toDisk: true)
                                }
                            })
                        }
                    }
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.black
        self.contentSize = CGSize.init(width: frame.size.width, height: frame.size.height)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 100.0
        self.setZoomScale(1.0, animated: false)

        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleDoubleTap))
        tapGestureRecognizer.numberOfTapsRequired = 2

        self.contentImageView.frame = self.bounds
        self.contentImageView.addGestureRecognizer(tapGestureRecognizer)
        self.addSubview(self.contentImageView)

        self.animateImageView.isHidden = true
        self.animateImageView.frame = self.bounds
        self.animateImageView.addGestureRecognizer(tapGestureRecognizer)
        self.addSubview(self.animateImageView)

        self.addSubview(self.circleProgressView)
        self.circleProgressView.snp.makeConstraints { (make: ConstraintMaker) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//MARK: - 适配长图显示

    func fitLongPicDisplay(displayImage: UIImage) {
        let width = GlobalProperties.SCREEN_WIDTH;
        let height = width * displayImage.size.height / displayImage.size.width;

        if (height > GlobalProperties.SCREEN_WIDTH) {
            self.contentImageView.contentMode = .scaleAspectFill
            self.contentImageView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
            self.contentSize = CGSize.init(width: width, height: height)
            self.contentOffset = CGPoint.init(x: 0, y: (height - GlobalProperties.SCREEN_HEIGHT) * 0.5)
        }
    }

//MARK: - 加载Gif

    func loadDisplayGif() {
        if let url = URL.init(string: self.imageUrl!) {
            DispatchQueue.global().async { [weak self] in
                guard let weakSelf = self else {
                    return
                }

                let filePath = "\(MediaToolKit.getCurrentUserGifPicSavePath(userId: "global"))\(weakSelf.imageUrl!)"
                if FileManager.default.fileExists(atPath: filePath) {
                    do {
                        let imageData = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
                        DispatchQueue.main.async { [weak self] in
                            guard let weakSelf = self else {
                                return
                            }

                            if let animateImage = FLAnimatedImage.init(animatedGIFData: imageData, optimalFrameCacheSize: 1, predrawingEnabled: false) {
                                weakSelf.circleProgressView.isHidden = true
                                weakSelf.animateImageView.animatedImage = animateImage
                            }
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    KingfisherManager.shared.downloader.downloadImage(with: url, retrieveImageTask: nil, options: nil, progressBlock: { [weak self] (receivedSize, totalSize) in
                        let progress = CGFloat(receivedSize) * 1.0 / CGFloat(totalSize)
                        DispatchQueue.main.async { [weak self] in
                            guard let weakSelf = self else {
                                return
                            }

                            weakSelf.circleProgressView.progress = progress
                        }
                    }) { [weak self] (image, error, url, data) in
                        guard let weakSelf = self else {
                            return
                        }

                        weakSelf.circleProgressView.isHidden = true

                        if let imageData = data {
                            DispatchQueue.main.async { [weak self] in
                                guard let weakSelf = self else {
                                    return
                                }

                                if let animateImage = FLAnimatedImage.init(animatedGIFData: imageData, optimalFrameCacheSize: 1, predrawingEnabled: false) {
                                    weakSelf.circleProgressView.isHidden = true
                                    weakSelf.animateImageView.animatedImage = animateImage
                                }
                            }

                            DispatchQueue.global().async {
                                do {
                                    try imageData.write(to: URL.init(fileURLWithPath: filePath), options: Data.WritingOptions.atomicWrite)
                                    KingfisherManager.shared.cache.clearMemoryCache()
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

//MARK: - 还原比例

    public func resetZoomScale() {
        self.setZoomScale(1.0, animated: false)
    }

//MARK: - 双击事件

    @objc func handleDoubleTap() {
        if self.isScaled {
            self.setZoomScale(1.0, animated: true)
        } else {
            self.setZoomScale(2.0, animated: true)
        }
        self.isScaled = !self.isScaled
    }

//MARK: - 组件

    let contentImageView = UIImageView.init().then { imageView in
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.isUserInteractionEnabled = true
    }

    let animateImageView = FLAnimatedImageView.init().then { imageView in
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.runLoopMode = RunLoop.Mode.default.rawValue
    }

    let circleProgressView = EvaCircleProgressView.init().then { progressView in
        progressView.isHidden = true
    }
}

extension EvaScaledImageDetailView: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for view in scrollView.subviews {
            return view;
        }
        return nil
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScaled = true
    }
}
