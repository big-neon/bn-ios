
import Foundation
import UIKit

final class ApplicationRouter {
    
    class func setupBaseRouting() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = UIColor.brandPrimary
        window.makeKeyAndVisible()
        //MARK: use guard instead or !userIsLoggedIn()
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
        //MARK: use guard  eg.

//        guard RoutingViewModel().fetchToken() else {
//            return false
//        }
//        return true
        
        let routingViewModel: RoutingViewModel = RoutingViewModel()
        if routingViewModel.fetchToken() == true {
            return true
        }
        return false
    }
}
