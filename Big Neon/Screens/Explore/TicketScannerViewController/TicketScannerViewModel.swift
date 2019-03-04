

import Foundation
import Big_Neon_Core

final class TicketScannerViewModel {

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

    internal func redeemFetchedKey(completion: @escaping(Bool) -> Void) {
        completion(true)
        return
    }

}
