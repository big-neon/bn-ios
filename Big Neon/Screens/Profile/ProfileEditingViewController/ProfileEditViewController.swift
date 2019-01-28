


import UIKit
import Big_Neon_UI

internal class ProfileEditViewController: UIViewController  {
    
    internal var profleEditViewModel: ProfileEditViewModel = ProfileEditViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.configureNavBar()
    }
    
    private func configureNavBar() {
        self.navigationClearBar()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setNavigationTitle(withTitle: "Account", titleColour: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
}

