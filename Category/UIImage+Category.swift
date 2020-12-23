//
//  UIImage+Category.swift
//  SwiftDevelopFramework
//
//  Created by tommy on 2016/10/26.
//  Copyright © 2016年 eva. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import GPUImage
import AVFoundation

typealias FetchImageDoneBlock = (UIImage?, String?) -> Void

extension UIImage {
    
    public static func getImage(imageName: String?) -> UIImage? {
        if (imageName != nil) {
            if let imagePath = Bundle.main.path(forResource: imageName, ofType: nil) {
                return UIImage.init(contentsOfFile: imagePath);
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    }
    
    public static func getImage(color: UIColor, size:CGSize, cornerRadius: CGFloat) -> UIImage? {
        
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale);
        
        let context = UIGraphicsGetCurrentContext();
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        
        var image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale);
        UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius).addClip();
        
        image?.draw(in: rect);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    
    public func imageWithCornerRadius(radius: CGFloat) -> UIImage? {

        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale);
        
        UIBezierPath.init(roundedRect: rect, cornerRadius: radius).addClip();
        self.draw(in: rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    
    public func scale(toSize: CGSize) -> UIImage? {
        //创建一个bitmap的context，并把它设置为当前正在使用的context
        UIGraphicsBeginImageContextWithOptions(toSize, false, UIScreen.main.scale);
        //绘制改变大小的图片
        self.draw(in: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: toSize));
        //从当前context中创建一个改变大小后的图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        //清空上下文
        UIGraphicsEndImageContext();
        //返回新的图片
        return resultImage;
    }
    
    public func circle() -> UIImage? {
        //1.设置图形的属性
        let borderWidth : CGFloat = 1.0;
        let borderColor = UIColor.clear;
        
        //2.取得尺寸小的边作为原型图片的半径
        let imageW = self.size.width + CGFloat(2 * borderWidth);
        let imageH = self.size.height + CGFloat(2 * borderWidth);
        let baseRadius = min(imageW, imageH);
        let imageSize = CGSize.init(width: baseRadius, height: baseRadius);
        
        //3.开启上下文，并取得当前上下文
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext();
        
        //4.画边框（大圆）
        borderColor.set();
        let bigRadius = baseRadius * 0.5;
        let centerX = bigRadius;
        let centerY = bigRadius;
        context?.addArc(center: CGPoint.init(x: centerX, y: centerY), radius: bigRadius, startAngle: 0, endAngle: CGFloat(Double.pi) * CGFloat(2), clockwise: false);
        context?.fillPath();
        
        //5.小圆
        let smallRadius = bigRadius - borderWidth;
        context?.addArc(center: CGPoint.init(x: centerX, y: centerY), radius: smallRadius, startAngle: 0, endAngle: CGFloat(Double.pi) * CGFloat(2), clockwise: false);
        context?.clip();
        
        //6.画图
        self.draw(in: CGRect.init(x: borderWidth, y: borderWidth, width: self.size.width, height: self.size.height));
        
        //7.取图
        let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resultImage;
    }
    
    public func clipSquarePartImageInScreen(percent: CGFloat,videoOrientation: AVCaptureVideoOrientation) -> UIImage {
        let imageWidth = self.size.width;
        let imageHeight = self.size.height;
        
        var resultRect = CGRect.init(x: 0, y: 0, width: 0, height: 0);
        
        if imageWidth == imageHeight {
            return self;
        } else {
            switch videoOrientation {
            case .portrait:
                resultRect = CGRect.init(x: 0, y: percent * (imageHeight - imageWidth) * self.scale, width: imageWidth * self.scale, height: imageWidth * self.scale);
            case .portraitUpsideDown:
                resultRect = CGRect.init(x: 0, y: (1 - percent) * (imageHeight - imageWidth) * self.scale, width: imageWidth * self.scale, height: imageWidth * self.scale);
            case .landscapeRight:
                resultRect = CGRect.init(x: percent * (imageWidth - imageHeight) * self.scale, y: 0, width: imageWidth * self.scale, height: imageWidth * self.scale);
            default:
                resultRect = CGRect.init(x: (imageWidth - imageHeight) * (1 - percent) * self.scale, y: 0, width: imageWidth * self.scale, height: imageWidth * self.scale);
                break
            }
        }
        
        let imageRef = self.cgImage;
        let imagePartRef = imageRef!.cropping(to: resultRect);
        
        let retImage = UIImage.init(cgImage: imagePartRef!);
        
        return retImage;
    }
    
    public func clipSquarePartImageInScreen() -> UIImage {
        let percent: CGFloat = 0.5
        let imageWidth = self.size.width;
        let imageHeight = self.size.height;
        let videoOrientation = (imageWidth > imageHeight) ? AVCaptureVideoOrientation.landscapeRight : AVCaptureVideoOrientation.portrait
        
        var resultRect = CGRect.init(x: 0, y: 0, width: 0, height: 0);
        
        if imageWidth == imageHeight {
            return self;
        } else {
            switch videoOrientation {
            case .portrait:
                resultRect = CGRect.init(x: 0, y: percent * (imageHeight - imageWidth) * self.scale, width: imageWidth * self.scale, height: imageWidth * self.scale);
            case .portraitUpsideDown:
                resultRect = CGRect.init(x: 0, y: (1 - percent) * (imageHeight - imageWidth) * self.scale, width: imageWidth * self.scale, height: imageWidth * self.scale);
            case .landscapeRight:
                resultRect = CGRect.init(x: percent * (imageWidth - imageHeight) * self.scale, y: 0, width: imageWidth * self.scale, height: imageWidth * self.scale);
            default:
                resultRect = CGRect.init(x: (imageWidth - imageHeight) * (1 - percent) * self.scale, y: 0, width: imageWidth * self.scale, height: imageWidth * self.scale);
                break
            }
        }
        
        let imageRef = self.cgImage;
        let imagePartRef = imageRef!.cropping(to: resultRect);
        
        let retImage = UIImage.init(cgImage: imagePartRef!);
        
        return retImage;
    }
    
    
    /*
     * 按特定比例切图片
     * @param: ratio: 图片的宽高比
     */
    public func clipImage(ratio:CGFloat) -> UIImage? {
        let width = self.size.width;
        let height = self.size.height;
        
        var resultImage: UIImage?;
        
        //开启图片上下文
        UIGraphicsBeginImageContextWithOptions(self.size, true, UIScreen.main.scale);
        
        //将图片会知道上下文中
        self.draw(in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height));
        
        //添加裁切
        if width >= height {
            //宽度大于高度
            let baseHeight = height;
            let resultWidth = ratio * baseHeight;
            let leftMargin = (width - resultWidth) * 0.5;
            
            let path = UIBezierPath.init(roundedRect: CGRect.init(x: leftMargin, y: 0, width: resultWidth, height: baseHeight), cornerRadius: 0);
            
            path.addClip();
        } else {
            //宽度小于高度
            let baseWidth = width;
            let resultHeight = baseWidth / ratio;
            let topMargin = (height - resultHeight) * 0.5;
            
            let path = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: topMargin, width: baseWidth, height: resultHeight), cornerRadius: 0);
            
            path.addClip();
        }
        
        //获取结果图片
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束图片上下文
        UIGraphicsEndImageContext();
        
        return resultImage;
    }
    
    public static func getImage(videoUrl: URL) -> UIImage? {
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey:false];
        let urlAsset = AVURLAsset.init(url: videoUrl, options: options);
        
        let generator = AVAssetImageGenerator.init(asset: urlAsset);
        generator.appliesPreferredTrackTransform = true;
        generator.maximumSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        do {
            let image = try generator.copyCGImage(at: CMTime.init(value: 10, timescale: 10), actualTime: nil);
        
            let resultImage = UIImage.init(cgImage: image);
            
            return resultImage;
        } catch {
            print(error);
            
            return nil;
        }
    }
    
    public func getDistorationImage(center: CGPoint ,radius: CGFloat,scale: CGFloat) -> UIImage {
        let filter = GPUImageBulgeDistortionFilter();
        filter.center = center;
        filter.radius = radius;
        filter.scale = scale;
        return filter.image(byFilteringImage: self);
    }
    
    
    // 尝试美颜
    public func getBeautyImage(complete handle: @escaping (_ image: UIImage?) -> Void) {
        //创建图片源
        let gpuImageSource = GPUImagePicture.init(image: self)
        
        let filterGroup = GPUImageFilterGroup.init()
        gpuImageSource?.addTarget(filterGroup)
        
        // 美白
        let brightnessFilter = GPUImageBrightnessFilter.init()
        brightnessFilter.brightness = 0.05
        self.addGpuImageFilter(filter: brightnessFilter, group: filterGroup)
        
        // 磨皮
        let bilateralFilter = GPUImageBilateralFilter.init()
//        bilateralFilter.distanceNormalizationFactor = 0.05
        self.addGpuImageFilter(filter: bilateralFilter, group: filterGroup)

        // 图片渲染
        gpuImageSource?.processImage()
        filterGroup.useNextFrameForImageCapture()
        handle(filterGroup.imageFromCurrentFramebuffer())
    }
    
    public func addGpuImageFilter(filter: GPUImageFilter, group: GPUImageFilterGroup) {
        group.addFilter(filter)
        
        if group.filterCount() == 1 {
            group.initialFilters = [filter]
            group.terminalFilter = filter
        } else {
            let terminalFilter = group.terminalFilter
            let initialFilter = group.initialFilters.first
            terminalFilter?.addTarget(filter)
            group.initialFilters = [initialFilter!]
            group.terminalFilter = filter
        }
    }
    
    public static func captureScrollViewToImage(scrollView: UIScrollView) -> UIImage? {
        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame
        
        scrollView.frame = CGRect.init(x: 0, y: scrollView.y, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, true, UIScreen.main.scale)
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedFrame
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    public func thumbnailImage(withSize size: CGSize, cornerRadius:CGFloat) -> UIImage? {
        var thumbnailImage: UIImage? = nil
        let originImageSize = self.size
        let newRect = CGRect.init(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(newRect.size,false,0.0);
        let ratio = max(newRect.size.width / originImageSize.width, newRect.size.height / originImageSize.height)
        let path = UIBezierPath.init(roundedRect: newRect, cornerRadius: cornerRadius)
        path.addClip()
        
        let projectRect = CGRect(x: (newRect.size.width - originImageSize.width * ratio) / 2,
                                 y: (newRect.size.height - originImageSize.height * ratio) / 2,
                                 width: originImageSize.width * ratio,
                                 height: originImageSize.height * ratio)
        
        self.draw(in: projectRect)
        
        thumbnailImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return thumbnailImage
    }
    
    private static func fetchRemoteVideoFirstFrameImage(url: String, fetchDoneBlock: @escaping FetchImageDoneBlock) {
        if let remoteUrl = URL.init(string: url) {
            DispatchQueue.global().async {
                let asset = AVURLAsset.init(url: remoteUrl, options: nil)
                let assetImageGenerator = AVAssetImageGenerator.init(asset: asset)
                assetImageGenerator.appliesPreferredTrackTransform = true
                assetImageGenerator.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
                
                do {
                    let imageRef = try assetImageGenerator.copyCGImage(at: CMTime.init(seconds: 0, preferredTimescale: 6), actualTime: nil)
                    
                    DispatchQueue.main.async {
                        fetchDoneBlock(UIImage.init(cgImage: imageRef), url)
                    }
                } catch {
                    DispatchQueue.main.async {
                        fetchDoneBlock(nil, nil)
                    }
                }
            }
        } else {
            fetchDoneBlock(nil, nil)
        }
    }
    
    public static func createQRImage(content: String, size: CGSize) -> UIImage? {
        var codeImage: UIImage?
        if ((UIDevice.current.systemVersion as NSString).floatValue >= Float(8.0)) {
            let stringData = content.data(using: .utf8)
            
            //生成
            let qrFilter = CIFilter.init(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("M", forKey: "inputCorrectionLevel")
            
            let onColor = UIColor.black
            let offColor = UIColor.white
            
            if let outputImage = qrFilter.outputImage {
                //上色
                if let colorFilter = CIFilter.init(name: "CIFalseColor", parameters: ["inputImage":outputImage, "inputColor0":CIColor.init(cgColor: onColor.cgColor), "inputColor1":CIColor.init(cgColor: offColor.cgColor)]) {
                    if let qrImage = colorFilter.outputImage {
                        if let cgImage = CIContext.init(options: nil).createCGImage(qrImage, from: qrImage.extent) {
                            UIGraphicsBeginImageContext(size)
                            let context = UIGraphicsGetCurrentContext()
                            context?.interpolationQuality = .none
                            context?.scaleBy(x: 1.0, y: -1.0)
                            context?.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
                            codeImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                        }
                    }
                }
            }
        }
        return codeImage
    }

    public static func captureLayer(layer: CALayer, size: CGSize) -> UIImage? {
        //1.开启上下文
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        //2.将控制器view的layer渲染到上下文
        layer.render(in: UIGraphicsGetCurrentContext()!)
        //3.取出绘制好的图片
        let layerImage = UIGraphicsGetImageFromCurrentImageContext()
        //4.结束上下文
        UIGraphicsEndImageContext()
        return layerImage
    }
    
    // 获取某个Bundle下的图片文件
    public static func ipz_image(named: String, bundleClass: AnyClass, bundleName: String) -> UIImage? {
        let frameworkBundle = Bundle(for: bundleClass)
        if let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent(bundleName) {
            let resourceBundle = Bundle(url: bundleURL)
            return UIImage(named: named, in: resourceBundle, compatibleWith: nil)
        } else {
            return nil
        }
    }
    
    // 获取IPZBase.bundle下的图片
    public static func ipzbase_image(named: String) -> UIImage? {
        if let tempClass = NSClassFromString("IPZBase.EvaBaseViewController") {
            let frameworkBundle = Bundle(for: tempClass)
            if let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("IPZBase.bundle") {
                let resourceBundle = Bundle(url: bundleURL)
                return UIImage(named: "\(named)@\(Int(UIScreen.main.scale))x.png", in: resourceBundle, compatibleWith: nil)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
