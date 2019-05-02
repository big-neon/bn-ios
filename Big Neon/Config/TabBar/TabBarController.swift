
import Foundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core

final class TabBarController: UITabBarController {
    
    fileprivate var navigationControllers: [UINavigationController] = []
    fileprivate let tabBarTitles = ["Doorperson", "My Tickets", "Profile"]
    fileprivate var currentNavigationIndex: Int = 0
    
    private let doorPersonController  = UINavigationController(rootViewController: TicketsViewController())
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
        UITabBar.appearance().tintColor = UIColor.brandPrimary
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(UIColor.brandPrimary,
                                                                                            size: CGSize(width: tabBar.frame.width/3,
                                                                                                         height: tabBar.frame.height))
        
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
        flowLayout.minimumLineSpacing = 16.0
        
        let tabBarItemImageExplore = UIImage(named: "ic_tab_explore")?.withRenderingMode(.alwaysTemplate)
        doorPersonController.tabBarItem = UITabBarItem(title: tabBarTitles[0], image: tabBarItemImageExplore, selectedImage: tabBarItemImageExplore)
        
        let tabBarItemImageTickets = UIImage(named: "ic_tab_ticket")?.withRenderingMode(.alwaysTemplate)
        ticketsController.tabBarItem = UITabBarItem(title: tabBarTitles[1], image: tabBarItemImageTickets, selectedImage: tabBarItemImageTickets)
        
        let profileTabBarItemImage = UIImage(named: "ic_tab_profile")?.withRenderingMode(.alwaysTemplate)
        profileController.tabBarItem = UITabBarItem(title: tabBarTitles[2], image: profileTabBarItemImage, selectedImage: profileTabBarItemImage)
        
        self.viewControllers = [doorPersonController, ticketsController, profileController]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let title: String = item.title else {
            return
        }
        self.currentNavigationIndex = tabBarTitles.index(of: title)!
    }
    
    internal func getNavigationControllerForCurrentPage() -> UINavigationController {
        return self.navigationControllers[self.currentNavigationIndex]
    }
    
}

extension UIImage {
    func makeImageWithColorAndSize(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

