
import Foundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core

final class TabBarController: UITabBarController {
    
    fileprivate var navigationControllers: [UINavigationController] = []
    fileprivate let tabBarTitles = ["Doorperson", "My Tickets", "Profile"]
    //MARK: do we need this one
    // UITabBarCOntroller has selectedIndex propery
    fileprivate var currentNavigationIndex: Int = 0
    
    private let doorPersonController  = UINavigationController(rootViewController: DoorPersonViewController())
    private let ticketsController   = UINavigationController(rootViewController: TicketsViewController())
    private let profileController  = UINavigationController(rootViewController: ProfileViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
        self.configureTabTintColour()
        self.setupViewControllers()
    }
    
    private func setupAppearance() {
        self.view.backgroundColor = UIColor.white
    }
    
    private func configureTabTintColour() {
        
        //MARK:  use abbreviation / syntax sugar
        // beter: use  let tabBarAppearance = UITabBar.appearance()
        
        UITabBar.appearance().tintColor = UIColor.brandPrimary
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(UIColor.brandPrimary,
                                                                                            size: CGSize(width: tabBar.frame.width/3,
                                                                                                         height: tabBar.frame.height))
        // MARK: self is not needed
        self.tabBar.isTranslucent = false
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.barTintColor = UIColor.white
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.brandBlack], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.brandPrimary], for: .selected)
    }
    
    private func setupViewControllers() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        // MARK: Magic number... use constant or some layout class / enum
        flowLayout.minimumLineSpacing = 16.0
        
        
        
        let tabBarItemImageExplore = UIImage(named: "ic_tab_explore")?.withRenderingMode(.alwaysTemplate)
        // MARK harcoded index of array?  not good - index can be out of range
        doorPersonController.tabBarItem = UITabBarItem(title: tabBarTitles[0], image: tabBarItemImageExplore, selectedImage: tabBarItemImageExplore)
        
        let tabBarItemImageTickets = UIImage(named: "ic_tab_ticket")?.withRenderingMode(.alwaysTemplate)
        ticketsController.tabBarItem = UITabBarItem(title: tabBarTitles[1], image: tabBarItemImageTickets, selectedImage: tabBarItemImageTickets)
        
        let profileTabBarItemImage = UIImage(named: "ic_tab_profile")?.withRenderingMode(.alwaysTemplate)
        profileController.tabBarItem = UITabBarItem(title: tabBarTitles[2], image: profileTabBarItemImage, selectedImage: profileTabBarItemImage)
        
        // MARK: self is not needed
        self.viewControllers = [doorPersonController, ticketsController, profileController]
        
        
        // MARK: just idea:
        // 1. use enum with row int values for tabBarTitles
        // 2. create all 3 navigationController is loop
        // in this way we dont need to properties for them and  we can get title in much safer way
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        
        guard let title: String = item.title else {
            return
        }
        // MARK: self is not needed
        // app will crash if there is no index for title... not likly but not good practice
        // put it in guard...
        self.currentNavigationIndex = tabBarTitles.index(of: title)!
        
        
    }
    
    // MARK: internal is default access level modifier - not needed
    internal func getNavigationControllerForCurrentPage() -> UINavigationController {
        // MARK: self is not needed
        return self.navigationControllers[self.currentNavigationIndex]
    }
    
}

// MARK: better to move to separate file
extension UIImage {
    func makeImageWithColorAndSize(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

