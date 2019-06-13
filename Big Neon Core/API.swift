

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
        let serverURL = Environment().configuration(PlistKey.ServerURL)
        let connectionProtocol = Environment().configuration(PlistKey.ConnectionProtocol)
        return "\(connectionProtocol)://\(serverURL)"
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
    public class func fetchEvents(eventID: String, changesSince: String?, page: Int?, limit: Int?, query: String?) -> String {
        var queryParams:[String] = []
        if let value = changesSince {
            queryParams.append("changes_since=" + value)
        }
        
        if let value = limit {
            queryParams.append("limit=\(value)")
        }
        if let value = page {
            queryParams.append("page=\(value)")
        }
        
        var queryString = ""
        if queryParams.count > 0 {
            queryString = "?\(queryParams.joined(separator: "&"))"
        }
        
        if let query = query {
           queryString += ("&query=" + query)
        }
        
        return self.baseURL() + "/events/\(eventID)/guests\(queryString)"
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
