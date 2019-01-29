


import UIKit
import Big_Neon_UI

internal class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    internal var profleEditViewModel: ProfileEditViewModel = ProfileEditViewModel()
    
    internal lazy var profileEditTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = UIColor.brandBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorColor = UIColor.brandGrey.withAlphaComponent(0.3)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.configureNavBar()
        self.configureAccountTableView()
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func configureNavBar() {
        self.navigationLineBar()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setNavigationTitle(withTitle: "Account", titleColour: UIColor.brandBlack)
        self.navigationController?.navigationBar.tintColor = UIColor.brandPrimary
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(handleSave))
    }
    
    private func configureAccountTableView() {
        self.view.addSubview(profileEditTableView)
        
        profileEditTableView.register(ProfileImageUploadCell.self, forCellReuseIdentifier: ProfileImageUploadCell.cellID)
        profileEditTableView.register(ProfileEditTableCell.self, forCellReuseIdentifier: ProfileEditTableCell.cellID)
        profileEditTableView.register(LogoutCell.self, forCellReuseIdentifier: LogoutCell.cellID)
        
        self.profileEditTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.profileEditTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.profileEditTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.profileEditTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func handleSave() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func handleLogout() {
        let alertController = UIAlertController(title: "Logout",
                                                message: nil, preferredStyle: .actionSheet)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .default, handler: { (_) -> Void in
            self.profleEditViewModel.handleLogout(completion: { (_) in
                let welcomeVC = UINavigationController(rootViewController: WelcomeViewController())
                welcomeVC.modalTransitionStyle = .flipHorizontal
                self.present(welcomeVC, animated: true, completion: nil)
                return
            })
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
        })
        
        alertController.addAction(confirmButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension ProfileEditViewController {
    
    @objc func keyboardWillShow( note:NSNotification ) {
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            var insets: UIEdgeInsets
            if profileEditTableView.contentInset.bottom == 0 {
                insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            } else {
                insets = UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 0 )
            }
            profileEditTableView.contentInset = insets
            profileEditTableView.scrollIndicatorInsets = insets
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        switch textField.tag {
        //        case 0:
        //            self.payoutsViewModel.bankName = textField.text!
        //        case 1:
        //            self.payoutsViewModel.accountNumber = textField.text!
        //        case 2:
        //            self.payoutsViewModel.accountHolder = textField.text!
        //        case 3:
        //            self.payoutsViewModel.branchCode = textField.text!
        //        default:
        //            self.payoutsViewModel.branchName = textField.text!
        //        }
    }
    
}

