//
//  String+Extension.swift
//  OstrichBlockChain
//
//  Created by tommy on 2018/1/3.
//  Copyright © 2018年 ipzoe. All rights reserved.
//

import Foundation

extension String {
    
    // 将原始的url编码为合法的url
    public func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    // 将编码后的url转换回原始的url
    public func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    public func isMobileNumberClassification() -> Bool {
        /**
         * 中国移动：China Mobile
         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
         */
        let CM = "^(134|135|136|137|138|139|147|148|150|151|152|157|158|159|172|178|182|183|184|187|188|198)[0-9]{8}$";
        
        
        /**
         * 中国联通：China Unicom
         * 130,131,132,152,155,156,185,186,1709
         */
        let CU = "^(130|131|132|145|146|155|156|166|171|175|176|185|186)[0-9]{8}$";
        
        /**
         * 中国电信：China Telecom
         * 133,1349,153,180,189,1700
         */
        let CT = "^(133|149|153|173|174|177|180|181|189|199|170)[0-9]{8}$";
        
        let regexTestCM = NSPredicate.init(format: "SELF MATCHES %@", CM);
        let regexTestCU = NSPredicate.init(format: "SELF MATCHES %@", CU);
        let regexTestCT = NSPredicate.init(format: "SELF MATCHES %@", CT);
        
        if (regexTestCM.evaluate(with: self) || regexTestCU.evaluate(with: self) || regexTestCT.evaluate(with: self)) {
            return true;
        } else {
            return false;
        }
    }
    
    public func convertToAttributedString(docAttributes:[NSAttributedString.Key : Any]?) -> NSMutableAttributedString? {
        
        if let htmlData = self.data(using: String.Encoding.utf8) {
            do {
                let attritedString = try NSMutableAttributedString.init(data: htmlData,
                                                                        options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                  NSAttributedString.DocumentReadingOptionKey("CharacterEncoding"): String.Encoding.utf8.rawValue],
                                                                        documentAttributes: nil)
                if let _ = docAttributes {
                    attritedString.addAttributes(docAttributes!, range: NSMakeRange(0, attritedString.length))
                }
                return attritedString
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    public func sizeWithFont(font: UIFont) -> CGSize {
        return sizeWithAttributes(attrs: [NSAttributedString.Key.font: font],
                                  constrainedSize: CGSize.init(width: Double(MAXFLOAT),
                                                               height: Double(MAXFLOAT)))
    }
    
    public func sizeWithAttributes(attrs: [NSAttributedString.Key : Any]?, constrainedSize: CGSize) -> CGSize {
        let attributedString = NSAttributedString.init(string: self, attributes: attrs)
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        let fitSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), nil, constrainedSize, nil)
        return fitSize
    }
    
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            
            return String(subString)
        } else {
            return self
        }
    }
    
    public func substring(to index: Int) -> String {
        if self.count > index {
            let endIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[self.startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    // Range转换为NSRange
    public func toNSRange(from range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }
    
    public func toRange(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    public func addHexPrefix() -> String {
        if !self.hasPrefix("0x") {
            return "0x" + self
        }
        return self
    }
    
    public func ranges(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = self.range(of: self) else {
            return rangeArray
        }
        searchedRange = sr
        
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }
    
    // 验证是否为登录密码格式（6-20位的数字字母）
    //
    // - Returns: Bool
    public func verifyLoginPasswordFormat() -> Bool {
        let regex = NSPredicate.init(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}$")
        return regex.evaluate(with: self)
    }
    
    public func phoneNumberProtection() -> String? {
        guard self.isMobileNumberClassification() else {
            return self
        }
        
        return self.replacingCharacters(in: self.toRange(from: NSRange.init(location: 3, length: 4))!,
                                        with: "****")
    }
    
    // 验证是否为邮箱地址
    //
    // - Returns: Bool
    public func verifyEmailAddressFormat() -> Bool {
        let regex = NSPredicate.init(format: "SELF MATCHES %@", "^[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?$")
        return regex.evaluate(with: self)
    }
    
    // 汉字转拼音  带声调
    //
    // - Parameter string: 汉字字符串
    // - Returns: 拼音
    public func convertToPinyinWithShengDiao() -> String {
        let mutableString = NSMutableString.init(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        return String(mutableString).replacingOccurrences(of: " ", with: "")
    }
    
    // 汉字转拼音  不带声调
    //
    // - Parameter string: 汉字字符串
    // - Returns: 拼音
    public func convertToPinyinWithoutShengDiao() -> String {
        let mutableString = NSMutableString.init(string: self.convertToPinyinWithShengDiao())
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, false)
        return String(mutableString).replacingOccurrences(of: " ", with: "")
    }
    
    // 格式化银行卡号
    //
    // - Returns: 格式化以后的银行卡号
    public func formatBankCard() -> String {
        let cardNumber = self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
        var cardNumbers = cardNumber.map({ String($0) })
        for index in 0..<(cardNumbers.count / 4) {
            cardNumbers.insert(" ", at: (index + 1) * 4 + index)
        }
        if let lastChar = cardNumbers.last, lastChar == " " {
            cardNumbers.removeLast()
        }
        return cardNumbers.joined(separator: "")
    }
}
