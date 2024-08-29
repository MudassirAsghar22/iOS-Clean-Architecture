//
//  Date+Extension.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import Foundation

extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start

    }

    func getElapsedInterval() -> String {
        var calendar = Calendar.current
        let localDateString = DateHelper.shared.dateFormatter(formate: .MM_dd_yyyy_HH_mm_ss).string(from: Date())
        let localDate = DateHelper.shared.getUnChangedDateFrom(dateString: localDateString, dateFormate: .MM_dd_yyyy_HH_mm_ss)!
        let interval = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: localDate)
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago":
            "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago":
            "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago":
            "\(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago":
            "\(hour)" + " " + "hours ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute ago":
            "\(minute)" + " " + "minutes ago"
        } else {
            return "a moment ago"
        }
    }

    var millisecondsSince1970:Double {
        return (self.timeIntervalSince1970 * 1000.0)
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

    func toLocalTime() -> Date {
        let timeZone = TimeZone.current
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
        return addingTimeInterval(seconds)
    }
}
