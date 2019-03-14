

import Foundation
import Big_Neon_Core

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
            default:
                guard let ticket = redeemTicket else {
                    completion(nil)
                    return
                }
                
                self.redeemableTicket = ticket
                completion(nil)
                return
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
                self.event = nil
                self.redeemableTicket = nil
                self.redeemedTicket = ticket!
                completion(.valid)
                return
            }
        }
    }

}
