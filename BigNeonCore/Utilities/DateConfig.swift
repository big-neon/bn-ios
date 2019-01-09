

import Foundation

import Foundation

final public class DateConfig {
    
    public class func dateFromString(stringDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'PST'"
        return dateFormatter.date(from: stringDate)
    }
    
    public class func eventDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, MMM dd"
        return dateFormatter.string(from: date)
    }
    
    public class func eventDateMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
    
    public class func eventDateValue(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
    
    public class func dateFromUTCString(stringDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: stringDate)
    }
    
    public class  func localTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EE, MMM dd"
        return dateFormatter.string(from: date)
    }
    
    /*
    public class func IntFromDate(date: Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    
    public class func DateFromInt(int: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(int)))
    }
    
    public class func getTimeString(forDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        return dateFormatter.string(from: date).lowercased()
    }
    
    public class func dateAndTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM, h:mm aa"
        return dateFormatter.string(from: date)
    }
    
    public class func DayFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    public class func hour(fromDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: date)
    }
    
    public class func minute(fromDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: date)
    }
    
    public class func MonthFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
    }
    
    public class func fullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        return dateFormatter.string(from: date)
    }
    
    class func getTimeStamp(fromDate date: Date) -> String? {
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "h:mm a"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d"
            return dateFormatter.string(from: date)
        }
    }
    
    class func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
    
    class func getDayWeek(weekDay:Int) -> String? {
        switch weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        default:
            return "Saturday"
        }
    }
    */
}

final internal class DayTimeHelper {
    
    // Adapted from "Time ago" - https://gist.github.com/minorbug/468790060810e0d29545
    
    class func getDayString(forDate date: Date, numericDates: Bool) -> String {
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekday, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date, to: latest as Date)
        let dateFormatterGet = DateFormatter()
        
        if (components.year! >= 1) {
            dateFormatterGet.dateFormat = "dd MMM"
            return dateFormatterGet.string(from: date).uppercased()
        } else if (components.month! >= 1) {
            dateFormatterGet.dateFormat = "dd MMM"
            return dateFormatterGet.string(from: date).uppercased()
        } else if (components.weekOfYear! >= 1) {
            dateFormatterGet.dateFormat = "dd MMM"
            return dateFormatterGet.string(from: date).uppercased()
        } else if (components.day! >= 1) {
            return "Yesterday"
        } else if (components.day! == 2) {
            dateFormatterGet.dateFormat = "hh:mm aa"
            return dateFormatterGet.string(from: date).uppercased()
        }
        dateFormatterGet.dateFormat = "hh:mm aa"
        return dateFormatterGet.string(from: date).uppercased()
    }
    
    class func getDateString(forDate date: Date) -> String {
        if date == Date() {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd MMM"
            return "Today \(dateFormatterGet.string(from: date))"
        }
        
        //  Get Date
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd MMMM"
        
        //  Get Week Day
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: date)
        let day = DayTimeHelper.getDayWeek(weekDay: weekDay)
        
        return "\(day!) \(dateFormatterGet.string(from: date))"
    }
    
    class func getTimeString(forDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        return dateFormatter.string(from: date).lowercased()
    }
    
    class func getDayWeek(weekDay:Int) -> String? {
        switch weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        default:
            return "Saturday"
        }
    }
}
