

import Foundation
import Alamofire
import JWTDecode

extension DatabaseService {
    
    public func tokenIsAvailable(completion: @escaping (Bool) -> Void) {
        
        // Fetch Access Token
        guard let accessToken = self.fetchAcessToken(), let refreshToken = self.fetchRefreshToken() else {
            completion(false)
            return
        }
        
        //  Fetch the Expiration Time
        
        
        do {
            let jwt = try decode(jwt: accessToken)
            let expired = jwt.expired
            if expired == true {
                completion(false)
                return
            }
            completion(true)
            return
        } catch {
            completion(false)
        }
        
    }
    
    public func fetchNewAccessToken(completion: @escaping (String?) -> Void) {
        guard let refreshToken = self.fetchRefreshToken() else {
            completion(nil)
            return
        }
        
        print(refreshToken)
        
        
    }
}
