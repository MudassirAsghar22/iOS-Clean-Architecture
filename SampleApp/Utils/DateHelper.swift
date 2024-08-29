//
//  DateHelper.swift
//  Sample App
//
//  Created by Mudassir Asghar on 22/05/2024.
//

import Foundation

struct DateTimeStrings {
    var timeString = ""
    var dateString = ""
}

enum DateIs {
    case today
    case passed
    case future
}

class DateHelper : NSObject {
    static let shared = DateHelper()

    func dateFormatter(formate: Constants.DateFormate) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate.rawValue
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }

    func isValidRangeOfDateStrings(dateFrom: Date, dateTo: Date ) -> Bool {
        if dateFrom.compare(dateTo) == .orderedSame || dateFrom.compare(dateTo) == .orderedAscending {
            return true
        } else {
            return false
        }
    }

    func getUnChangedDateFrom(dateString: String, dateFormate: Constants.DateFormate) -> Date? {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = dateFormate.rawValue

        guard let dateWithNoChange = timeFormatter.date(from: dateString) else {
            return nil
        }
        return dateWithNoChange
    }

    func getDayNameFrom(dateStr: String, inputFormate: Constants.DateFormate) -> String {

        guard let date = self.getUnChangedDateFrom(dateString: dateStr, dateFormate: inputFormate) else { return "" }
        var calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date)
        // let weekDay = myComponents
        switch weekDay {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thur"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "Invalid Day Name"
        }

    }

    func getMonthNameFrom(dateStr: String, inputFormate: Constants.DateFormate) -> String {

        guard let date = self.getUnChangedDateFrom(dateString: dateStr, dateFormate: inputFormate) else {return "" }
        var calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.month, from: date)

        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"

        default:
            return "Invalid Day Name"
        }

    }

    func getDayNameFromDate(date: Date) -> String {

        var calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date)
        // let weekDay = myComponents
        switch weekDay {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thur"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "Invalid Day Name"
        }

    }

    func getCurrentMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatter.locale = .current
        dateFormatter.timeZone = TimeZone.current
        let nameOfMonth = dateFormatter.string(from: Date())
        return nameOfMonth

    }

    func getCurrentYear() -> Int {
        var calendar = Calendar.current
        return calendar.component(.year, from: Date())

    }

    func getCurrentDayFromDate(date: Date) -> Int {
        var calendar = Calendar.current
        return calendar.component(.day, from: date)
    }

    func getCurrentMonthFromDate(date: Date) -> Int {
        var calendar = Calendar.current
        return calendar.component(.month, from: date)
    }

    func getMonthNameFrom(dateString: String, inputFormate: Constants.DateFormate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = self.getUnChangedDateFrom(dateString: dateString, dateFormate: inputFormate) else { return "" }
        let nameOfMonth = dateFormatter.string(from: date)
        return nameOfMonth
    }

    func offsetFrom(dateTo:Date, dateFrom: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: dateFrom, to: dateTo)

        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours

        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        return days
    }

    func offsetStringFrom(dateFrom: String, dateTo: String) -> String {
        var calendar = Calendar.current
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute]

        guard let fromDate = self.getUnChangedDateFrom(dateString: dateFrom, dateFormate: .yyyy_MM_dd_HH_mm_ss), let toDate = self.getUnChangedDateFrom(dateString: dateTo, dateFormate: .yyyy_MM_dd_HH_mm_ss) else { return "" }

        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond,
                                                           from: fromDate,
                                                           to: toDate)
        if difference.day! > 0 {
            if difference.hour! > 0 {
                return "\(difference.day!) day(s), \(difference.hour!) hour(s) ago"
            } else {
                return "\(difference.day!) day(s) ago"
            }
        } else if difference.hour! > 0 {
            if difference.minute! > 1 {
                return "\(difference.hour!) hour(s), \(difference.minute!) min(s) ago"
            } else {
                return "\(difference.hour!) hour(s) ago"
            }
        } else if difference.minute! > 0 {
            return "\(difference.minute!) min(s) ago"
        } else {
            return ""
        }
    }

    func checkDate(_ dateString: String, dateFormat: Constants.DateFormate) -> DateIs? {
        let dateFormatter = self.dateFormatter(formate: dateFormat)

        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                return .today
            } else if date < Date() {
                return .passed
            } else {
                return .future
            }
        } else {
            return nil
        }
    }
}
