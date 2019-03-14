

public enum APIParameterKeys {
    public static let requestSetValue      = "application/json; charset=utf-8"
    public static let headerField          = "Content-Type"
    public static let authorization        = "Authorization"
    public static let POST                 = "POST"
    public static let GET                  = "GET"
    public static let PUT                  = "PUT"

}

public class APIService {
    
    private static let baseURL = "https://beta.bigneon.com/api"
    
    /**
     URL: /events/{event_id}/redeem/{ticket_id}
     */
    class func redeemTicket(eventID: String, ticketID: String) -> String {
        return baseURL + "/events/\(eventID)/redeem/\(ticketID)"
    }
    
    /**
     URL: "/tickets/{ticketID}/redeem
     */
    class func getRedeemableTicket(ticketID: String) -> String {
        return baseURL + "/tickets/\(ticketID)/redeem"
    }
    
    /**
     - Retrieves Events from the Database
     */
    class func getEvents(eventID: String?) -> String {
        if eventID == nil {
           return baseURL + "/events"
        }
        return baseURL + "/events/\(eventID!)"
    }
    
    /**
     - Retrieves all the Checkin Events
     */
    class func getCheckins() -> String {
        return baseURL + "/events/checkins"
    }
    
    /**
     - Retrieves all the Checkin Events
     */
    class func users() -> String {
        return baseURL + "/users"
    }
    
    /**
     - Logs in the Users
     */
    class func login() -> String {
        return baseURL + "/auth/token"
    }
    
    /**
     - Updates the User Details
     */
    class func updateUser() -> String {
        return baseURL + "/users/me"
    }
    
    /**
     - Retrieves an Access Token using the Refresh Token
     */
    class func refreshToken() -> String {
        return baseURL + "/auth/token/refresh"
    }
    
}
