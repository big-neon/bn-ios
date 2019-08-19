
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
        
        BusinessService.shared.database.checkTokenExpirationAndUpdate { (tokenResult, error) in
            if error != nil {
                print(error)
                completion(false)
                return
            }
            
            switch tokenResult {
            case .noAccessToken?:
               print("No Access Token Found")
               completion(false)
            case .tokenExpired?:
                print("Token has expired")
                completion(false)
            default:
                self.fetchCheckins(completion: { (completed) in
                    completion(completed)
                    return
                })
            }
        }
    }
    
    func fetchCheckins(completion: @escaping(Bool) -> Void) {
        self.events = nil
        BusinessService.shared.database.checkTokenExpirationAndUpdate { (tokenResult, error) in
            if error != nil {
                print(error)
                completion(false)
                return
            }
            
            switch tokenResult {
            case .noAccessToken?:
               print("No Access Token Found")
               completion(false)
            case .tokenExpired?:
                print("Token has expired")
                completion(false)
            default:
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
        }
    }
    
    func fetchUser(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.checkTokenExpirationAndUpdate { (tokenResult, error) in
            if error != nil {
                print(error)
                completion(false)
                return
            }
            
            switch tokenResult {
            case .noAccessToken?:
               print("No Access Token Found")
               completion(false)
            case .tokenExpired?:
                print("Token has expired")
                completion(false)
            default:
                BusinessService.shared.database.fetchUser() { (error, userFound) in
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
        
    }
    
}
