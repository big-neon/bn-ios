
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class ExploreViewModel {
    
    internal var events: Events?
    internal var checkins: Checkins?
    
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
            print(events)
            self.events = events

            completion(true)
            return
        }
        
    }
    
    internal func fetchCheckins(completion: @escaping(Bool) -> Void) {
        self.checkins = nil
        BusinessService.shared.database.fetchCheckins { (error, checkins) in
            if error != nil {
                completion(false)
                return
            }
            
            guard let checkins = checkins else {
                completion(false)
                return
            }
            print(checkins)
            self.checkins = checkins
            
            completion(true)
            return
        }
        
    }
    
    internal func handleLogout(completion: @escaping (Bool) -> Void) {
        BusinessService.shared.database.logout { (completed) in
            completion(completed)
        }
    }
    
}
