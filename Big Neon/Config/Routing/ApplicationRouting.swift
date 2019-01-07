
import Foundation
import UIKit

final class ApplicationRouter {
    
    class func setupBaseRouting() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = UIColor.red
        window.makeKeyAndVisible()
        if userIsLoggedIn() == false {
            let navController = TabBarController()
            window.rootViewController = navController
            return window
        }
        let navVC = UINavigationController(rootViewController: SplashViewController())
        window.rootViewController = navVC
        return window
    }
    
    class func userIsLoggedIn() -> Bool {
//        if Auth.auth().currentUser != nil {
//            return true
//        }
        return true
    }
}
