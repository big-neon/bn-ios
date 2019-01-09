

public enum APIParameterKeys {
    public static let requestSetValue      = "application/json; charset=utf-8"
    public static let headerField          = "Content-Type"
    public static let POST                 = "POST"
    public static let GET                  = "GET"
    
}

public enum APIService {
    
    private static let stagingBaseURL = "https://beta.bigneon.com/api"
    
    // Staging
    public static let getEvents =  stagingBaseURL + "/events"
    
    //  Production
}
