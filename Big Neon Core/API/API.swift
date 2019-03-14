

public enum APIParameterKeys {
    public static let requestSetValue      = "application/json; charset=utf-8"
    public static let headerField          = "Content-Type"
    public static let authorization        = "Authorization"
    public static let POST                 = "POST"
    public static let GET                  = "GET"
    public static let PUT                  = "PUT"
    
}

public enum APIService {
    
    // Staging
    private static let stagingBaseURL = "https://beta.bigneon.com/api"
    
    //  Production
    
    public static let getEvents     =  stagingBaseURL + "/events"
    public static let getCheckins   =  stagingBaseURL + "/events/checkins"
    public static let users         =  stagingBaseURL + "/users"
    public static let login         =  stagingBaseURL + "/auth/token"
    public static let updateUser    = stagingBaseURL + "/users/me"
    public static let refreshToken  = stagingBaseURL + "/auth/token/refresh"
    public static let redeem        = stagingBaseURL + "/tickets/"
}

public class StagingAPIService {
    
    private static let baseURL = "https://beta.bigneon.com/api"
    
    /**
     URL: /events/{event_id}/redeem/{ticket_id}
     */
    class func redeemTicket(eventID: String, ticketID: String) -> String {
        return baseURL + "/events/\(eventID)/redeem/\(ticketID)"
    }
}
