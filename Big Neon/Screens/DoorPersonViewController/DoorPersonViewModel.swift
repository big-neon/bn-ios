
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper
import CoreData

final class DoorPersonViewModel {
    
    var events: Events?
    var event: Event?
    var eventCoreData: [EventsData] = []
    var todayEvents: [EventsData] = []
    var upcomingEvents: [EventsData] = []
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
