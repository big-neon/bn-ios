
import Foundation
import Big_Neon_Core
import CoreData
import Sync

final class GuestsListViewModel {
    
    var totalGuests: Int?
    var currentTotalGuests: Int = 0
    var currentPage: Int = 1
    let limit = 100
    var ticketsFetched: [RedeemableTicket] = []
    var eventID: String?

    internal func fetchGuests(forEventID eventID: String, page: Int, completion: @escaping(Bool) -> Void) {
        
        print(currentTotalGuests)
        print(ticketsFetched.count)
        
        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page) { [weak self] (error, guestsFetched, serverGuests, totalGuests) in
            DispatchQueue.main.async {
                
                //  Core Data Checks
                /*
                 guard let _ = guestsFetched, error != nil else {
                 completion(false)
                 return
                 }
                 */
                
                guard let guests = serverGuests else {
                    completion(false)
                    return
                }
                
                self?.totalGuests = totalGuests
                self?.ticketsFetched += guests.data
                self?.currentTotalGuests += guests.data.count
                self?.currentPage += 1
                completion(true)
                return
            }
        }
    }
    
}
