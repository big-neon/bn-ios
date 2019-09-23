

import Foundation

import Foundation

final public class DateConfig {
    
    public class func formatServerDate(date: String, timeZone: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateFetched = self.dropMilliseconds(date: date)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let utcDate = dateFormatter.date(from: dateFetched)
        let tz = TimeZone(identifier: timeZone)!
        dateFormatter.timeZone = tz
        guard let convertedDate = utcDate else {
            return nil
        }
        return  dateFormatter.date(from: dateFormatter.string(from: convertedDate))
    }
    
    public class func eventDateIsToday(eventStartDate: String) -> Bool {
        return DateConfig.eventDate(date: DateConfig.dateFromUTCString(stringDate: eventStartDate)!) == DateConfig.eventDate(date: Date())
    }

    private class func dropMilliseconds(date:String) -> String{
        let dateParts = date.components(separatedBy: ".")
        return dateParts[0]
    }
    
    public class func eventDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, MMM dd"
        return dateFormatter.string(from: date)
    }
    
    public class func eventFullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM YYYY"
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
    
    public class func stringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    public class func serverDateFromDate(stringDate: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'UTC'HH:mm:ss"
        return dateFormatter.string(from: stringDate)
    }
    
    public class  func localTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EE, MMM dd"
        return dateFormatter.string(from: date)
    }
    
    public class  func dateFormatShort(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM/dd/YY"
        return dateFormatter.string(from: date)
    }
    
    public class  func dateFormatLong(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEEE, dd MMMM YYYY"
        return dateFormatter.string(from: date)
    }
    
    public class  func fullDateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEEE dd MMMM - HH:mm"
        return dateFormatter.string(from: date)
    }
   
}

final internal class DayTimeHelper {
    
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


public extension Date {
    
    func getElapsed() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else if let hours = interval.hour, hours > 0 {
            return hours == 1 ? "\(hours)" + " " + "hour ago" :
                "\(hours)" + " " + "hours ago"
        } else if let minutes = interval.minute, minutes > 0 {
            return minutes == 1 ? "\(minutes)" + " " + "minute ago" :
                "\(minutes)" + " " + "minutes ago"
        } else {
            return "A moment ago"
        }
    }
}
