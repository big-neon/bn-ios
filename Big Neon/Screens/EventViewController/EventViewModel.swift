



import Foundation
import Big_Neon_Core
import CoreData
import Sync

final class EventViewModel {
    
    var eventData: EventsData?
    var guests: Guests?
    var totalGuests: Int?
    var eventTimeZone: String?
    var currentTotalGuests: Int = 0
    var currentPage: Int = 0
    let limit = 100
    var guestCoreData: [GuestData] = []
    var ticketsFetched: [RedeemableTicket] = []
    var guestSearchResults: [RedeemableTicket] = []

    func fetchNextEventGuests(page: Int, completion: @escaping(Bool) -> Void) {

        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(false)
                return
            }

            self.fetchGuests(page: page) { (completed) in
                completion(completed)
                return
            }
        }
    }
    
    func fetchGuests(page: Int, completion: @escaping(Bool) -> Void) {

        guard let eventID = self.eventData!.id else {
            completion(false)
            return
        }

        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page, guestQuery: nil) { [weak self] (error, guestsFetched, serverGuests, totalGuests) in
            DispatchQueue.main.async {

                //  Core Data Checks
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
    
    func fetchSearchGuests(withQuery query: String?, page: Int?, isSearching: Bool, completion: @escaping(Bool) -> Void) {
        
        guard let eventID = self.eventData?.id else {
            completion(false)
            return
        }
        
        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page, guestQuery: query) { [weak self] (error, guestsFetched, serverGuests, totalGuests) in
            DispatchQueue.main.async {
                guard let guests = serverGuests else {
                    completion(false)
                    return
                }
                
                if isSearching == true {
                    self?.guestSearchResults = guests.data
                    completion(true)
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
