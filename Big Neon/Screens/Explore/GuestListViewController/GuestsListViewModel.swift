
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
    var eventTimeZone: String?
    var ticketsUpdated: [RedeemableTicket] = []
    var guestSearchResults: [RedeemableTicket] = []

    func fetchGuests(forEventID eventID: String, page: Int, completion: @escaping(Bool) -> Void) {
        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page, guestQuery: nil) { [weak self] (error, guestsFetched, serverGuests, totalGuests) in
            DispatchQueue.main.async {
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
    
    func fetchGuests(andQuery query: String?, page: Int?, isSearching: Bool, completion: @escaping(Bool) -> Void) {
        
        guard let eventID = eventID else {
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
    
    func fetchNewTicketUpdates(forEventID eventID: String, eventTimeZone: String, completion: @escaping(Bool) -> Void) {
        
        var date = ""
        let changeSince = UserDefaults.standard.value(forKey: Constants.AppActionKeys.changeSinceKey) as? String
        if changeSince == nil {
            date = DateConfig.stringFromDate(date: Date())
        } else {
            date = changeSince!
        }
        
        BusinessService.shared.database.fetchUpdatedGuests(forEventID: eventID, changeSince: date) { (error, guestsFetched) in
            DispatchQueue.main.async {
                guard var guests = guestsFetched else {
                    completion(false)
                    return
                }
                
                print(guests)
                
                guests.sort(by: {DateConfig.formatServerDate(date: ($0["updated_at"] as! String), timeZone: eventTimeZone)! > DateConfig.formatServerDate(date: ($1["updated_at"] as! String), timeZone: eventTimeZone)!})
                
                if let lastUpdateValue = guests.first {
                    UserDefaults.standard.set(lastUpdateValue["updated_at"] as! String, forKey: Constants.AppActionKeys.changeSinceKey)
                    completion(true)
                    return
                }
            }
        }
    }
    
    private func configureEventDate(event: EventsData) -> String {
        let utcEventStart = event.event_start
        
        guard let timezone = event.venue else {
            return "-"
        }
        
        guard let eventDate = DateConfig.formatServerDate(date: utcEventStart!, timeZone: timezone.timezone!) else {
            return "-"
        }
        return DateConfig.dateFormatShort(date: eventDate)
    }
    
    
    
}
