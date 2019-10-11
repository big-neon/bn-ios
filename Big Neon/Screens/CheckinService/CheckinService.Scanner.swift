

import Foundation
import Big_Neon_Core


extension CheckinService {
    
    func setScannerModeFirstTime() -> Bool {
        if UserDefaults.standard.bool(forKey: Constants.CheckingMode.scannerCheckinConfiguredKey) == false {
           UserDefaults.standard.set(true, forKey: Constants.CheckingMode.scannerCheckinKey)
            UserDefaults.standard.set(true, forKey: Constants.CheckingMode.scannerCheckinConfiguredKey)
            UserDefaults.standard.synchronize()
            return true
        } else {
            return false
        }
    }

    func setCheckingModeAutomatic() {
        UserDefaults.standard.set(true, forKey: Constants.CheckingMode.scannerCheckinKey)
        UserDefaults.standard.synchronize()
    }

    func setCheckingModeManual() {
        UserDefaults.standard.set(false, forKey: Constants.CheckingMode.scannerCheckinKey)
        UserDefaults.standard.synchronize()
    }

    func scannerMode() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.CheckingMode.scannerCheckinKey)
    }

    func getRedeemKey(fromStringValue value: String) -> String? {
        guard let data = try? JSONSerialization.jsonObject(with: Data(value.utf8), options: []),
            let dataValue = data as? [String: Any],
            let redeemKeyData = dataValue["data"] as? [String:String] else {
            return nil
        }
        return redeemKeyData["redeem_key"]
    }
    
    func getTicketID(fromStringValue value: String) -> String? {
        guard let data = try? JSONSerialization.jsonObject(with: Data(value.utf8), options: []),
            let dataValue = data as? [String: Any],
            let redeemKeyData = dataValue["data"] as? [String:String] else {
                
            return nil
        }
        return redeemKeyData["id"]
    }

    func getRedeemTicket(ticketID: String, completion: @escaping(ScanFeedback?, String?) -> Void) {
        BusinessService.shared.database.getRedeemTicket(forTicketID: ticketID) { (scanFeedback, errorString, redeemTicket) in
            DispatchQueue.main.async {
                
                self.scanVC?.scannedTicket = redeemTicket
                
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
                    completion(.validTicketID, errorString)
                    return
                default:
                    print("No Data Returned")
                    return
                }
            }
        }
    }
    
/*
    func fetchEventGuests(forEventID eventID: String, page: Int, completion: @escaping(Bool) -> Void) {
        
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(false)
                return
            }
        
            self.fetchGuests(forEventID: eventID, page: page) { (completed) in
                completion(completed)
                return
            }
        }
    }
    
    func fetchGuests(forEventID eventID: String, page: Int, completion: @escaping(Bool) -> Void) {
        
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
*/
}
