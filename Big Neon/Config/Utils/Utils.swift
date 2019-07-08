
import Foundation
import UIKit
import Big_Neon_Core
import SwiftKeychainWrapper

public class Utils: NSObject {
    
    // MARK: extension ?
    static func showAlert(presenter: UIViewController, title: String, message: String?) {
        //MARK:  use abbreviation / syntax sugar  eg.
        // UIAlertController.Style.alert  can be written as just  .alert
        // UIAlertAction.Style.default can be written as just .default
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func showActionSheet(presenter: UIViewController, title: String, message: String?) {
        //MARK:  use abbreviation / syntax sugar
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func saveTokensInKeychain(token: Tokens) {
        KeychainWrapper.standard.set(token.accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(token.refreshToken, forKey: "refreshToken")
        return
    }
}
