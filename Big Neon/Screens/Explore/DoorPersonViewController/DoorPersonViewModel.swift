
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper
import CoreData

final class DoorPersonViewModel {
    
    var events: Events?
    var event: Event?
    var eventCoreData: [EventsData] = []
    var user: User?
    
    func fetchEvents(completion: @escaping(Bool) -> Void) {
        self.events = nil
        BusinessService.shared.database.fetchEvents { [weak self](error, eventsFetched) in
            guard error != nil, let events = eventsFetched, let self = self else {
                completion(false)
                return
            }
            
            self.events = events
            completion(true)
            return
        }
    }
    
    func configureAccessToken(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.tokenIsExpired { [weak self] (expired) in
            guard let self = self else {
                completion(false)
                return
            }
            
            if expired == true {
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
    
    func fetchNewAccessToken(completion: @escaping(Bool) -> Void) {
        BusinessService.shared.database.fetchNewAccessToken { [weak self] (error, tokens) in
            
            guard let self = self, let tokens = tokens else {
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
    
    func fetchCheckins(completion: @escaping(Bool) -> Void) {
        self.events = nil
        BusinessService.shared.database.fetchCheckins { [weak self] (error, events) in
            
            guard let self = self, error != nil , let events = events else {
                completion(false)
                return
            }
            
            self.events = events
            self.fetchUser(completion: { (_) in
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
    
   func handleLogout(completion: @escaping (Bool) -> Void) {
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
