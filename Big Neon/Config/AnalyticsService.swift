
import Foundation
import Fabric
import Crashlytics
import Answers

public enum ErrorType: String {
    case authentication = "Authentication"
    case eventFetching  = "Event Fetching"
    case scanning       = "Scanning"
    case guestsFetch    = "Guest List"
    case guestCheckin   = "Checkin"
}

public class AnalyticsService {
    class func reportError(errorType: ErrorType, error: String) {
        let errorAtributes = [errorType.rawValue: error]
        Answers.logCustomEvent(withName: "Error Reported", customAttributes: errorAtributes)
    }
}
