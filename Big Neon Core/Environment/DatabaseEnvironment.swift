
import Foundation

public struct Environment {
    
    private static let production : Bool = {
        #if DEBUG
            print("DEBUG")
            let dic = ProcessInfo.processInfo.environment
            if let forceProduction = dic["forceProduction"] , forceProduction == "true" {
                return true
            }
            return false
        #else
            print("PRODUCTION")
            return true
        #endif
    }()
    
    public static func isProduction () -> Bool {
        return self.production
    }
}
