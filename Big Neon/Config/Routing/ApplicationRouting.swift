
import Foundation
import UIKit

final class ApplicationRouter {
    
    class func setupBaseRouting() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = UIColor.brandPrimary
        window.makeKeyAndVisible()
        if !userIsLoggedIn() {
            let navController = UINavigationController(rootViewController: WelcomeViewController())
            window.rootViewController = navController
            return window
        }
        let navVC = UINavigationController(rootViewController: SplashViewController())
        window.rootViewController = navVC
        return window
    }
    
    
    class func userIsLoggedIn() -> Bool {
        guard RoutingViewModel().fetchToken() else {
            return false
        }
        return true
    }
}
