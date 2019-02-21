
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class ExploreViewModel {
    
    internal var events: Events?
    
    internal func fetchEvents(completion: @escaping(Bool) -> Void) {
        self.events = nil
        BusinessService.shared.database.fetchEvents { (error, eventsFetched) in
            if error != nil {
                completion(false)
                return
            }

            guard let events = eventsFetched else {
                completion(false)
                return
            }
            
            self.events = events
            completion(true)
            return
        }
        
    }
    
    internal func configureAccessToken(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.tokenIsExpired { (expired) in
            if expired == true {
                //  Fetch New Token
                self.fetchNewAccessToken(completion: { (completed) in
                    completion(completed)
                    return
                })
            } else {
                self.fetchCheckins(completion: { (completed) in
                    completion(completed)
                    return
                })
            }
        }
    }
    
    internal func fetchNewAccessToken(completion: @escaping(Bool) -> Void) {
        BusinessService.shared.database.fetchNewAccessToken { (error, tokens) in
            guard let tokens = tokens else {
                completion(false)
                return
            }
            
            self.saveTokensInKeychain(token: tokens)
            self.fetchCheckins(completion: { (completed) in
                completion(completed)
                return
            })
        }
    }
    
    internal func fetchCheckins(completion: @escaping(Bool) -> Void) {
        self.events = nil
        BusinessService.shared.database.fetchCheckins { (error, events) in
            if error != nil {
                completion(false)
                return
            }
            
            guard let events = events else {
                completion(false)
                return
            }
            
            self.events = events
            
            completion(true)
            return
        }
        
    }
    
    internal func handleLogout(completion: @escaping (Bool) -> Void) {
        BusinessService.shared.database.logout { (completed) in
            completion(completed)
        }
    }
    
    private func saveTokensInKeychain(token: Tokens) {
        KeychainWrapper.standard.set(token.accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(token.refreshToken, forKey: "refreshToken")
        return
    }
    
}
