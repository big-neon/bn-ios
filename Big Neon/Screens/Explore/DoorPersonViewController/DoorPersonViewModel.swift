
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
            
            AnalyticsService.reportError(errorType: ErrorType.eventFetching, error: error?.localizedDescription ?? "")
            
            guard let self = self, let tokens = tokens else {
                completion(false)
                return
            }
            
            Utils.saveTokensInKeychain(token: tokens)
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
                AnalyticsService.reportError(errorType: ErrorType.eventFetching, error: error?.localizedDescription ?? "")
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
    
    func fetchUser(completion: @escaping(Bool) -> Void) {
        
        guard let accessToken = BusinessService.shared.database.fetchAcessToken() else {
            completion(false)
            return
        }
        
        BusinessService.shared.database.fetchUser(withAccessToken: accessToken) { (error, userFound) in
            guard let user = userFound else {
                completion(false)
                return
            }
            
            self.user = user
            completion(true)
            return
        }
        
    }
    
}
