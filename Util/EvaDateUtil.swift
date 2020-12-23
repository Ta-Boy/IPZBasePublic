//
//  EvaDateUtil.swift
//  SwiftDevelopFramework
//
//  Created by tommy on 2016/10/25.
//  Copyright © 2016年 eva. All rights reserved.
//

import UIKit

class EvaDateUtil: NSObject {
    
    public static func getTimeString(timeStamp: Int64) -> String {
        let dateFormatter = DateFormatter.init();
        
        let messageDate = Date.init(timeIntervalSince1970: Double(timeStamp / 1000));
        let currentDate = Date.init();
        
        let isSameDay = self.twoDateIsSameDay(firstDate: messageDate, secondDate: currentDate);
        let isMessageYesterday = self.isDateYesterday(date: messageDate);
        
        if isSameDay {
            dateFormatter.dateFormat = "HH:mm";
        } else if isMessageYesterday {
            dateFormatter.dateFormat = "昨天 HH:mm";
        } else {
            if self.twoDateIsSameYear(firstDate: messageDate, secondDate: currentDate) {
                dateFormatter.dateFormat = "MM-dd HH:mm";
            } else {
                dateFormatter.dateFormat = "yyyy-MM-dd";
            }
        }
        
        return dateFormatter.string(from: messageDate);
    }
    
    public static func twoDateIsSameDay(firstDate: Date, secondDate: Date) -> Bool {
        let calendar = Calendar.current;
        var unit = Set<Calendar.Component>();
        unit.insert(.month);
        unit.insert(.year);
        unit.insert(.day);
        
        let firstComponents = calendar.dateComponents(unit, from: firstDate);
        let secondComponents = calendar.dateComponents(unit, from: secondDate);
        
        if ((firstComponents.day == secondComponents.day)
            && (firstComponents.month == secondComponents.month)
            && (firstComponents.year == secondComponents.year)) {
            return true;
        }
        
        return false;
    }
    
    public static func twoDateIsSameYear(firstDate: Date, secondDate: Date) -> Bool {
        let calendar = Calendar.current;
        var unit = Set<Calendar.Component>();
        unit.insert(.year);
        
        let firstComponents = calendar.dateComponents(unit, from: firstDate);
        let secondComponents = calendar.dateComponents(unit, from: secondDate);
        
        if (firstComponents.year == secondComponents.year) {
            return true;
        }
        
        return false;
    }
    
    public static func isDateYesterday(date: Date) -> Bool {
        let calendar = Calendar.current;
        var unit = Set<Calendar.Component>();
        unit.insert(.month);
        unit.insert(.year);
        unit.insert(.day);
        
        let firstComponents = calendar.dateComponents(unit, from: date);
        let currentComponents = calendar.dateComponents(unit, from: Date.init());
        
        if ((firstComponents.day! - currentComponents.day! == 1)
            && (firstComponents.month == currentComponents.month)
            && (firstComponents.year == currentComponents.year)) {
            return true;
        }
        
        return false;
    }
    
    public static func isDateToday(date: Date) -> Bool {
        return twoDateIsSameDay(firstDate: Date.init(), secondDate: date);
    }

    public static func getChineseWeekDay(date: Date) -> String {
        let calendar = Calendar.current
        let weekDay = calendar.component(Calendar.Component.weekday, from: date)
        var weekDayChinese = ""
        //范围是从1－7。星期日是1
        switch weekDay {
            case 1:
                weekDayChinese = "星期日"
                break
            case 2:
                weekDayChinese = "星期一"
                break
            case 3:
                weekDayChinese = "星期二"
                break
            case 4:
                weekDayChinese = "星期三"
                break
            case 5:
                weekDayChinese = "星期四"
                break
            case 6:
                weekDayChinese = "星期五"
                break
            case 7:
                weekDayChinese = "星期六"
                break
            default:
                break
        }
        return weekDayChinese
    }
}
