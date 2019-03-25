

import Foundation
import Big_Neon_Core
import CoreData

final class TicketScannerViewModel {
    
    internal var event: Event?
    internal var redeemableTicket: RedeemableTicket?
    internal var redeemedTicket: RedeemableTicket?

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

    internal func getRedeemTicket(ticketID: String, completion: @escaping(ScanFeedback?) -> Void) {
        BusinessService.shared.database.getRedeemTicket(forTicketID: ticketID) { (scanFeedback, redeemTicket) in
            
            DispatchQueue.main.async {
                switch scanFeedback {
                case .alreadyRedeemed?:
                    completion(.alreadyRedeemed)
                    return
                case .issueFound?:
                    completion(.issueFound)
                    return
                case .wrongEvent?:
                    completion(.wrongEvent)
                    return
                case .validTicketID?:
                    guard let ticket = redeemTicket else {
                        completion(.validTicketID)
                        return
                    }
                    self.redeemableTicket = ticket
                    completion(.validTicketID)
                    return
                default:
                    print("No Data Returned")
                    return
                }
            }
        }
        
    }
    
    internal func getRedeemKey(fromStringValue value: String) -> String? {
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
    
    internal func completeCheckin(completion: @escaping(ScanFeedback) -> Void) {
        guard let eventID = self.event?.id else {
            completion(.issueFound)
            return
        }
        
        guard let ticket = self.redeemableTicket else {
            completion(.issueFound)
            return
        }
        
        BusinessService.shared.database.redeemTicket(forTicketID: ticket.id, eventID: eventID, redeemKey: ticket.redeemKey) { (scanFeedback, ticket) in
            DispatchQueue.main.async {
                switch scanFeedback {
                case .alreadyRedeemed:
                    completion(.alreadyRedeemed)
                    return
                case .issueFound:
                    completion(.issueFound)
                    return
                case .wrongEvent:
                    completion(.wrongEvent)
                    return
                default:
                    self.saveRedeemedTicket(ticket: self.redeemableTicket!, completion: { (completed) in
                        self.redeemableTicket = nil
                        self.redeemedTicket = ticket!
                        completion(.valid)
                        return
                    })
                }
            }
            
        }
    }

}

extension TicketScannerViewModel {
    
    internal func saveRedeemedTicket(ticket: RedeemableTicket, completion: @escaping(Bool) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "RedeemedTicket", in: context)
        let newTicket = NSManagedObject(entity: entity!, insertInto: context)
        print(RedeemableTicket.CodingKeys.id.rawValue)
        newTicket.setValue(ticket.id, forKey: RedeemableTicket.CodingKeys.id.rawValue)
        newTicket.setValue(ticket.ticketType, forKey: RedeemableTicket.CodingKeys.ticketType.rawValue)
        newTicket.setValue(ticket.userID, forKey: RedeemableTicket.CodingKeys.userID.rawValue)
        newTicket.setValue(ticket.orderID, forKey: RedeemableTicket.CodingKeys.orderID.rawValue)
        newTicket.setValue(ticket.orderItemID, forKey: RedeemableTicket.CodingKeys.orderItemID.rawValue)
        newTicket.setValue(ticket.priceInCents, forKey: RedeemableTicket.CodingKeys.priceInCents.rawValue)
        newTicket.setValue(ticket.firstName, forKey: RedeemableTicket.CodingKeys.firstName.rawValue)
        newTicket.setValue(ticket.lastName, forKey: RedeemableTicket.CodingKeys.lastName.rawValue)
        newTicket.setValue(ticket.email, forKey: RedeemableTicket.CodingKeys.email.rawValue)
        newTicket.setValue(ticket.phone, forKey: RedeemableTicket.CodingKeys.phone.rawValue)
        newTicket.setValue(ticket.redeemKey, forKey: RedeemableTicket.CodingKeys.redeemKey.rawValue)
        newTicket.setValue(ticket.redeemDate, forKey: RedeemableTicket.CodingKeys.redeemDate.rawValue)
        newTicket.setValue(ticket.status, forKey: RedeemableTicket.CodingKeys.status.rawValue)
        newTicket.setValue(ticket.eventID, forKey: RedeemableTicket.CodingKeys.eventID.rawValue)
        newTicket.setValue(ticket.eventName, forKey: RedeemableTicket.CodingKeys.eventName.rawValue)
        newTicket.setValue(ticket.doorTime, forKey: RedeemableTicket.CodingKeys.doorTime.rawValue)
        newTicket.setValue(ticket.eventStart, forKey: RedeemableTicket.CodingKeys.eventStart.rawValue)
        newTicket.setValue(ticket.venueID, forKey: RedeemableTicket.CodingKeys.venueID.rawValue)
        newTicket.setValue(ticket.venueName, forKey: RedeemableTicket.CodingKeys.venueName.rawValue)
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed saving")
            completion(false)
        }
    }
}
