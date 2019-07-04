

import Foundation
import Fabric
import Crashlytics
import Answers

public enum ErrorType: String {
    case authentication = "Authentication"
    case eventFetching  = "Event Fetching"
    case scanning       = "Scanning"
    case guestlistFetch = "Fetching Guestlist"
    case guestlistCheckin = "Guest List Checkin"
}

public class AnalyticsService {

    public class var shared: AnalyticsService {
        struct Static {
            static let instance: AnalyticsService = AnalyticsService()
        }
        return Static.instance
    }

    public init() {
    }

    public func reportError(errorType: ErrorType, error: String) {
        let errorAtributes = [errorType.rawValue: error]
        Answers.logCustomEvent(withName: "Error Reported", customAttributes: errorAtributes)
    }

}
