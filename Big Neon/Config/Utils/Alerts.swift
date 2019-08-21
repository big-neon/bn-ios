
import UIKit
import Foundation

extension UIViewController {
    
    func showAlert(presenter: UIViewController, title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(presenter: UIViewController, title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
}
