

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
        
        BusinessService.shared.database.getRedeemKey(ticketID: ticketID) { (error, redeemTicket) in
            if error != nil {
                
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

}
