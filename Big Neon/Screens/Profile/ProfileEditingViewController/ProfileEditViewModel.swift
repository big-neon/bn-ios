


import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class ProfileEditViewModel {
    
    internal let profileEditLabels: [String] = ["First Name", "Last Name", "Mobile", "Email", "Password"]
    
    internal var firstName: String?
    internal var lastName: String?
    internal var mobileNumber: String?
    internal var email: String?
    
    internal var user: User?
    
    internal func updateUserAccount(accountNumber: Int, accountHolder: String, bankName: String, branchCode: Int, branchName: String, completion: @escaping(Bool) -> Void) {
        
//        let bankAccount = PayoutBankAccount(accountNumber: accountNumber, accountHolder: accountHolder, bankName: bankName, branchCode: branchCode, branchName: branchName)
//
//        guard let driver = BusinessService.shared.authentication.loggedInDriver else {
//            completion(false)
//            return
//        }
//
//        BusinessService.shared.database.updateDriverBankRecord(driver: driver, bankRecord: bankAccount) { (error) in
//            if error != nil {
//                completion(false)
//                return
//            }
//
//            completion(true)
//            return
//        }
    }

    internal func handleLogout(completion: @escaping (Bool) -> Void) {
        BusinessService.shared.database.logout { (completed) in
            completion(completed)
        }
    }
}
