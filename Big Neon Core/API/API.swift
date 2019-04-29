

public enum APIParameterKeys {
    public static let requestSetValue      = "application/json; charset=utf-8"
    public static let headerField          = "Content-Type"
    public static let authorization        = "Authorization"
    public static let POST                 = "POST"
    public static let GET                  = "GET"
    public static let PUT                  = "PUT"

}

public class APIService {
    
    private class func baseURL() -> String {
        let isProduction = Environment.isProduction()
        if isProduction == true {
            return "https://api.production.bigneon.com"
        } else {
            return "https://api.staging.bigneon.com"
        }
    }
    
    /**
     URL: /events/{event_id}/redeem/{ticket_id}
     */
    class func redeemTicket(eventID: String, ticketID: String) -> String {
        return self.baseURL() + "/events/\(eventID)/redeem/\(ticketID)"
    }
    
    /**
     URL: /events/{event_id}/guests
     */
    public class func fetchEvents(eventID: String) -> String {
        return self.baseURL() + "/events/\(eventID)/guests"
    }
    
    /**
     URL: "/tickets/{ticketID}/redeem
     */
    class func getRedeemableTicket(ticketID: String) -> String {
        return self.baseURL() + "/tickets/\(ticketID)/redeem"
    }
    
    /**
     - Retrieves Events from the Database
     */
    public class func getEvents(eventID: String?) -> String {
        if eventID == nil {
           return self.baseURL() + "/events"
        }
        return self.baseURL() + "/events/\(eventID!)"
    }
    
    /**
     - Retrieves all the Checkin Events
     */
    public class func getCheckins() -> String {
        return self.baseURL() + "/events/checkins"
    }
    
    /**
     - Retrieves all the Checkin Events
     */
    public class func users() -> String {
        return self.baseURL() + "/users"
    }
    
    /**
     - Logs in the Users
     */
    public class func login() -> String {
        return self.baseURL() + "/auth/token"
    }
    
    /**
     - Updates the User Details
     */
    public class func updateUser() -> String {
        return self.baseURL() + "/users/me"
    }
    
    /**
     - Retrieves an Access Token using the Refresh Token
     */
    public class func refreshToken() -> String {
        return self.baseURL() + "/auth/token/refresh"
    }
    
}
