//
//  NSString+Category.swift
//  SwiftDevelopFramework
//
//  Created by tommy on 2016/10/26.
//  Copyright © 2016年 eva. All rights reserved.
//

import UIKit

extension NSString {
    
    public func sizeWithFont(font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font:font];
        return size(withAttributes: attributes);
    }
    
    public func sizeWithFont(font: UIFont, lineSpacing: CGFloat) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle.init();
        paragraphStyle.lineSpacing = lineSpacing;
        
        let attributes = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paragraphStyle];
        
        return size(withAttributes: attributes);
    }
    
    public func sizeWithFont(font: UIFont, lineSpacing: CGFloat, maxSize: CGSize) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle.init();
        paragraphStyle.lineSpacing = lineSpacing;
        
        let attributes = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paragraphStyle];
        
        return boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size;
    }
    
    
    public func getAttributedString(font: UIFont, lineSpacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle.init();
        paragraphStyle.lineSpacing = lineSpacing;
        
        let attributes = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paragraphStyle];
        return NSAttributedString.init(string: self as String, attributes: attributes);
    }

    
    public func isBlankString() -> Bool {
        if self.isEqual(to: "") {
            return true;
        } else if self.isKind(of: NSNull.classForCoder()) {
            return true;
        } else if (self.replacingOccurrences(of: " ", with: "").count == 0) {
            return true;
        } else if (self.replacingOccurrences(of: "\n", with: "").count == 0) {
            return true;
        }
        return false;
    }
    
    
    public func isMobileNumberClassification() -> Bool {
//        /**
//         * 中国移动：China Mobile
//         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
//         */
//        let CM = "^(134|135|136|137|138|139|147|148|150|151|152|157|158|159|172|178|182|183|184|187|188|198)[0-9]{8}$";
//
//
//        /**
//         * 中国联通：China Unicom
//         * 130,131,132,152,155,156,185,186,1709
//         */
//        let CU = "^(130|131|132|145|146|155|156|166|171|175|176|185|186)[0-9]{8}$";
//
//        /**
//         * 中国电信：China Telecom
//         * 133,1349,153,180,189,1700
//         */
//        let CT = "^(133|149|153|173|174|177|180|181|189|199|170)[0-9]{8}$";
//
//        let regexTestCM = NSPredicate.init(format: "SELF MATCHES %@", CM);
//        let regexTestCU = NSPredicate.init(format: "SELF MATCHES %@", CU);
//        let regexTestCT = NSPredicate.init(format: "SELF MATCHES %@", CT);
//
//        if (regexTestCM.evaluate(with: self) || regexTestCU.evaluate(with: self) || regexTestCT.evaluate(with: self)) {
//            return true;
//        } else {
//            return false;
//        }

        if self.length == 11 {
            return true;
        } else {
            return false;
        }
    }
    
    public func toPinyin() -> String {
        let mutableString = NSMutableString.init(string: self);
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false);
        return mutableString as String;
    }
    
    public func timeToChinese(dateFormat: String) -> String {
        //创建格式化工具
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = dateFormat;
        
        if let date = dateFormatter.date(from: self as String) {
            let calendar = Calendar.current;
            let dateComponts = calendar.dateComponents([.year,.month,.day], from: date);
            
            let year = dateComponts.year;
            let month = dateComponts.month;
            let day = dateComponts.day;
            
            let yearStr = getYearString(inputString: "\(year!)");
            let monthStr = getMonthString(inputMonth: month!);
            let dayStr = getDayString(inputDay: day!);
            
            return "\(yearStr)\(monthStr)\(dayStr)";
        } else {
            return self as String;
        }
    }
    
    public func getYearString(inputString: String) -> String {
        var resultStr: String = "";
        for i in inputString {
            switch i {
            case "0":
                resultStr = resultStr.appending("零");
                break;
            case "1":
                resultStr = resultStr.appending("一");
                break;
            case "2":
                resultStr = resultStr.appending("二");
                break;
            case "3":
                resultStr = resultStr.appending("三");
                break;
            case "4":
                resultStr = resultStr.appending("四");
                break;
            case "5":
                resultStr = resultStr.appending("五");
                break;
            case "6":
                resultStr = resultStr.appending("六");
                break;
            case "7":
                resultStr = resultStr.appending("七");
                break;
            case "8":
                resultStr = resultStr.appending("八");
                break;
            case "9":
                resultStr = resultStr.appending("九");
                break;
            default:
                break
            }
        }
        resultStr = resultStr.appending("年");
        return resultStr;
    }
    
    public func getMonthString(inputMonth: Int) -> String {
        
        var resultStr: String = "";
        
        if inputMonth < 10 {
            resultStr = resultStr.appending(numToChinese(input: inputMonth));
        } else {
            var decadeMonthStr = numToChinese(input: inputMonth / 10);
            if inputMonth / 10 == 1 {
                decadeMonthStr = "";
            }
            let restMonth = numToChinese(input: inputMonth % 10);
            
            resultStr = resultStr.appending("\(decadeMonthStr)十\(restMonth)");
        }
        resultStr = resultStr.appending("月");
        return resultStr;
    }
    
    public func getDayString(inputDay: Int) -> String {
        
        var resultStr: String = "";
        
        if inputDay < 10 {
            resultStr = resultStr.appending(numToChinese(input: inputDay));
        } else {
            var decadeDayStr = numToChinese(input: inputDay / 10);
            if inputDay / 10 == 1 {
                decadeDayStr = "";
            }
            let restDayStr = numToChinese(input: inputDay % 10);
            
            resultStr = resultStr.appending("\(decadeDayStr)十\(restDayStr)");
        }
        resultStr = resultStr.appending("日");
        return resultStr;
    }
    
    private func numToChinese(input: Int) -> String{
        var resultStr: String = "";
        
        switch input {
        case 0:
            resultStr = resultStr.appending("零");
            break;
        case 1:
            resultStr = resultStr.appending("一");
            break;
        case 2:
            resultStr = resultStr.appending("二");
            break;
        case 3:
            resultStr = resultStr.appending("三");
            break;
        case 4:
            resultStr = resultStr.appending("四");
            break;
        case 5:
            resultStr = resultStr.appending("五");
            break;
        case 6:
            resultStr = resultStr.appending("六");
            break;
        case 7:
            resultStr = resultStr.appending("七");
            break;
        case 8:
            resultStr = resultStr.appending("八");
            break;
        case 9:
            resultStr = resultStr.appending("九");
            break;
        default:
            break
        }
        
        return resultStr;
    }

    public func getCharacterCount() -> Int {
        let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        if let data = self.data(using: enc) {
            return data.count
        } else {
            return 0
        }
    }
}
