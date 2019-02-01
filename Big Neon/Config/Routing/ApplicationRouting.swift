
import Foundation
import UIKit

final class ApplicationRouter {
    
    
    class func setupBaseRouting() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = UIColor.brandPrimary
        window.makeKeyAndVisible()
        if userIsLoggedIn() == false {
            let navController = UINavigationController(rootViewController: WelcomeViewController())
            window.rootViewController = navController
            return window
        }
        let navVC = UINavigationController(rootViewController: SplashViewController())
        window.rootViewController = navVC
        return window
    }
    
    class func userIsLoggedIn() -> Bool {
        let routingViewModel: RoutingViewModel = RoutingViewModel()
        if routingViewModel.fetchToken() == true {
            return true
        }
        return false
    }
}
