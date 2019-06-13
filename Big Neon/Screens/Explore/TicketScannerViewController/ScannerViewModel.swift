

import Foundation
import Big_Neon_Core
import CoreData
import Sync

final class TicketScannerViewModel {
    
    var redeemedTicket: RedeemableTicket?
    var lastRedeemedTicket: RedeemableTicket?
    var scanVC: ScannerViewController?
    var guests: Guests?
    var dataStack: DataStack?
    
    var totalGuests: Int?
    var currentTotalGuests: Int = 0
    var currentPage: Int = 0
    let limit = 100
    var ticketsFetched: [RedeemableTicket] = []
    
    //  Event Infor
    var eventID: String?

    internal func setCheckingModeAutomatic() {
        UserDefaults.standard.set(true, forKey: Constants.CheckingMode.scannerCheckinKey)
        UserDefaults.standard.synchronize()
    }

    internal func setCheckingModeManual() {
        UserDefaults.standard.set(false, forKey: Constants.CheckingMode.scannerCheckinKey)
        UserDefaults.standard.synchronize()
    }

    internal func scannerMode() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.CheckingMode.scannerCheckinKey)
    }
    
    internal func getRedeemKey(fromStringValue value: String) -> String? {
        // MARK: use just one guard
        guard let data = try? JSONSerialization.jsonObject(with: Data(value.utf8), options: []) else {
            return nil
        }
        
        guard let dataValue = data as? [String: Any] else {
            return nil
        }
        guard let redeemKeyData = dataValue["data"] as? [String:String] else {
            return nil
        }
        return redeemKeyData["redeem_key"]
    }
    
    internal func getTicketID(fromStringValue value: String) -> String? {
        // MARK: use just one guard
        guard let data = try? JSONSerialization.jsonObject(with: Data(value.utf8), options: []) else {
            return nil
        }
        
        guard let dataValue = data as? [String: Any] else {
            return nil
        }
        guard let redeemKeyData = dataValue["data"] as? [String:String] else {
            return nil
        }
        return redeemKeyData["id"]
    }

    internal func getRedeemTicket(ticketID: String, completion: @escaping(ScanFeedback?, String?) -> Void) {
        BusinessService.shared.database.getRedeemTicket(forTicketID: ticketID) { (scanFeedback, errorString, redeemTicket) in
            DispatchQueue.main.async {
                switch scanFeedback {
                case .alreadyRedeemed?:
                    completion(.alreadyRedeemed, errorString)
                    return
                case .issueFound?:
                    completion(.issueFound, errorString)
                    return
                    
                case .wrongEvent?:
                    completion(.wrongEvent, errorString)
                    return
                case .validTicketID?:
                    self.scanVC?.scannedTicket = redeemTicket
                    completion(.validTicketID, errorString)
                    return
                default:
                    print("No Data Returned")
                    return
                }
            }
        }
    }
    
    internal func completeCheckin(ticket: RedeemableTicket,completion: @escaping(ScanFeedback) -> Void) {
        
        guard let eventID = self.scanVC?.event?.id else {
            completion(.issueFound)
            return
        }
        
        BusinessService.shared.database.redeemTicket(forTicketID: ticket.id, eventID: eventID, redeemKey: ticket.redeemKey) { [weak self] (scanFeedback, ticket) in
            DispatchQueue.main.async {
                self?.redeemedTicket = ticket
                completion(scanFeedback)
            }
        }
    }
    
    internal func automaticallyCheckin(ticketID: String, completion: @escaping(ScanFeedback?, String?, RedeemableTicket?) -> Void) {
        
        BusinessService.shared.database.getRedeemTicket(forTicketID: ticketID) { (scanFeedback, errorString, redeemTicket) in
            DispatchQueue.main.async {
                
                if scanFeedback == .validTicketID {
                    guard let ticket = redeemTicket else {
                        completion(.ticketNotFound, errorString, redeemTicket)
                        return
                    }
                    
                    guard let eventID = self.scanVC?.event?.id else {
                        completion(.issueFound, errorString, redeemTicket)
                        return
                    }
                    
                    self.completeAutoCheckin(eventID: eventID, ticket: ticket, completion: { (scanFeedback) in
                        completion(scanFeedback, errorString, redeemTicket)
                        return
                    })
                } else {
                    completion(scanFeedback, errorString, redeemTicket)
                }
            }
        }
    }
    
    internal func completeAutoCheckin(eventID: String, ticket: RedeemableTicket, completion: @escaping(ScanFeedback) -> Void) {
        
        BusinessService.shared.database.redeemTicket(forTicketID: ticket.id, eventID: eventID, redeemKey: ticket.redeemKey) { [weak self] (scanFeedback, ticket) in
            DispatchQueue.main.async {
                self?.redeemedTicket = ticket
                completion(scanFeedback)
            }
        }
    }

    
    internal func fetchGuests(forEventID eventID: String, page: Int, completion: @escaping(Bool) -> Void) {
        
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
}
