

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
            return "https://bigneon.com/api"
        } else {
            return "https://beta.bigneon.com/api"
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
    class func fetchEvents(eventID: String) -> String {
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
    class func getEvents(eventID: String?) -> String {
        if eventID == nil {
           return self.baseURL() + "/events"
        }
        return self.baseURL() + "/events/\(eventID!)"
    }
    
    /**
     - Retrieves all the Checkin Events
     */
    class func getCheckins() -> String {
        return self.baseURL() + "/events/checkins"
    }
    
    /**
     - Retrieves all the Checkin Events
     */
    class func users() -> String {
        return self.baseURL() + "/users"
    }
    
    /**
     - Logs in the Users
     */
    class func login() -> String {
        return self.baseURL() + "/auth/token"
    }
    
    /**
     - Updates the User Details
     */
    class func updateUser() -> String {
        return self.baseURL() + "/users/me"
    }
    
    /**
     - Retrieves an Access Token using the Refresh Token
     */
    class func refreshToken() -> String {
        return self.baseURL() + "/auth/token/refresh"
    }
    
}
