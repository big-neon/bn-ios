
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
        
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(completed)
                return
            }
            /*
            self.fetchCheckins(completion: { (completed) in
                completion(completed)
                return
            })
            */
        }
    }
    
    /*
    func fetchCheckins(completion: @escaping(Bool) -> Void) {
        self.events = nil

        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(completed)
                return
            }

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
     */
    
    func fetchUser(completion: @escaping(Bool) -> Void) {
        
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(completed)
                return
            }
            
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
