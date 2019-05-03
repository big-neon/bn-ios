
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

// MARK: self is not needed
// MARK: internal is default access level - not need for explicit definition



final class DoorPersonViewModel {
    
    internal var events: Events?
    internal var user: User?
    
    internal func fetchEvents(completion: @escaping(Bool) -> Void) {
        self.events = nil
        BusinessService.shared.database.fetchEvents { [weak self](error, eventsFetched) in
            // guard ?
            // MARK: put error and events under same guard
            if error != nil {
                completion(false)
                return
            }

            guard let events = eventsFetched else {
                completion(false)
                return
            }
            
            self?.events = events
            completion(true)
            return
        }
        
    }
    
    internal func configureAccessToken(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.tokenIsExpired { [weak self] (expired) in
            // idea:
//            guard `self` = self else {
//                completion(false)
//                return
//            }
            
            if expired == true {
                //  Fetch New Token
                self?.fetchNewAccessToken(completion: { (completed) in
                    completion(completed)
                    return
                })
            } else {
                self?.fetchCheckins(completion: { (completed) in
                    completion(completed)
                    return
                })
            }
        }
    }
    
    internal func fetchNewAccessToken(completion: @escaping(Bool) -> Void) {
        BusinessService.shared.database.fetchNewAccessToken { [weak self] (error, tokens) in
            guard let tokens = tokens else {
                completion(false)
                return
            }
            
            self?.saveTokensInKeychain(token: tokens)
            self?.fetchCheckins(completion: { (completed) in
                completion(completed)
                return
            })
        }
    }
    
    internal func fetchCheckins(completion: @escaping(Bool) -> Void) {
        self.events = nil
        BusinessService.shared.database.fetchCheckins { [weak self] (error, events) in
            
            // guard ?
            // MARK: put error and events under same guard
            if error != nil {
                completion(false)
                return
            }
            
            guard var events = events else {
                completion(false)
                return
            }
            self?.events = events
            
            self?.fetchUser(completion: { (_) in
                completion(true)
                return
            })
        }
        
    }
    
    private func fetchUser(completion: @escaping(Bool) -> Void) {
        
        guard let accessToken = BusinessService.shared.database.fetchAcessToken() else {
            completion(false)
            return
        }
        
        BusinessService.shared.database.fetchUser(withAccessToken: accessToken) { [weak self] (error, userFound) in
            guard let user = userFound else {
                completion(false)
                return
            }
            
            self?.user = user
            completion(true)
            return
        }
        
    }
    
    internal func handleLogout(completion: @escaping (Bool) -> Void) {
        BusinessService.shared.database.logout { (completed) in
            completion(completed)
        }
    }
    
    // MARK: idea: saveTokensInKeychain(token: Tokens, forKeys: [String])
    // make it accessible for other classes to use it
    // should be part of helper or util class 
    private func saveTokensInKeychain(token: Tokens) {
        KeychainWrapper.standard.set(token.accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(token.refreshToken, forKey: "refreshToken")
        return
    }
    
}
