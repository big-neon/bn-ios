

import Foundation
import Big_Neon_Core

final class TicketScannerViewModel {
    
    internal var event: Event?
    internal var redeemedTicket: RedeemedTicket?

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

    internal func getRedeemTicket(ticketID: String, completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.getRedeemTicket(forTicketID: ticketID) { (error, redeemTicket) in
            if error != nil {
                print("Error Found while Scanning Ticket: \(error)")
                completion(false)
                return
            }
            
            guard let ticket = redeemTicket else {
                completion(false)
                return
            }
            self.redeemedTicket = ticket
            completion(true)
            return
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

}
