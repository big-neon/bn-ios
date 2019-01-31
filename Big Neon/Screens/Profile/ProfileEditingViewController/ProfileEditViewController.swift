


import UIKit
import Big_Neon_UI

internal class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, ProfileImageUploadDelegate  {
    
    
    internal var profleEditViewModel: ProfileEditViewModel = ProfileEditViewModel()
    internal let picker = UIImagePickerController()
    
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
        self.profleEditViewModel.configureUserData()
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
        
        profileEditTableView.register(ProfileEditPhoneNumberTableCell.self, forCellReuseIdentifier: ProfileEditPhoneNumberTableCell.cellID)
        profileEditTableView.register(ProfileImageUploadCell.self, forCellReuseIdentifier: ProfileImageUploadCell.cellID)
        profileEditTableView.register(ProfileEditTableCell.self, forCellReuseIdentifier: ProfileEditTableCell.cellID)
        profileEditTableView.register(LogoutCell.self, forCellReuseIdentifier: LogoutCell.cellID)
        
        self.profileEditTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.profileEditTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.profileEditTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.profileEditTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func handleSave() {
        
        guard let firstName = self.profleEditViewModel.firstName else {
            Utils.showAlert(presenter: self, title: "First Name Missing", message: "Please add your name before saving")
            return
        }
        
        guard let lastName = self.profleEditViewModel.lastName else {
            Utils.showAlert(presenter: self, title: "Last Name Missing", message: "Please add your last name")
            return
        }
        
        guard let phone = self.profleEditViewModel.mobileNumber else {
            Utils.showAlert(presenter: self, title: "Mobile Number Missing", message: "Please add your mobile number")
            return
        }
        
        guard let email = self.profleEditViewModel.email else {
            Utils.showAlert(presenter: self, title: "Email Missing", message: "Please add your email")
            return
        }
        
        print(firstName)
        print(lastName)
        print(phone)
        print(email)
        
        self.profleEditViewModel.updateUserAccount(firstName: firstName, lastName: lastName, phone: phone, email: email) { (error) in
            if error == nil {
                self.dismiss(animated: true, completion: {
                    print("Reload the Profile Screen")
                })
                return
            }
            
            print("Error while saving the data: \(error?.localizedDescription)")
            return
        }
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
    
    func uploadImage() {
        let alertController = UIAlertController(title: "Upload a Profile Picture",
                                                message: nil, preferredStyle: .actionSheet)
        
        let takePhotoButton = UIAlertAction(title: "Take a photo", style: .default, handler: { (_) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.delegate = self
                self.picker.allowsEditing = true
                self.picker.sourceType = .camera
                
                self.picker.cameraDevice = .front
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker, animated: true, completion: nil)
            }
        })
        
        let  photoLibraryButton = UIAlertAction(title: "Pick from library", style: .default, handler: { (_) -> Void in
            self.picker.delegate = self
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
        })
        
        alertController.addAction(takePhotoButton)
        alertController.addAction(photoLibraryButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.tag)
        print(textField.text)
        
        switch textField.tag {
        case 0:
            self.profleEditViewModel.firstName = textField.text!
            return
        case 1:
            self.profleEditViewModel.lastName = textField.text!
            return
        case 2:
            self.profleEditViewModel.mobileNumber = textField.text!
            return
        case 3:
            self.profleEditViewModel.email = textField.text!
            return
        default:
            print("Meant to be Password Editing area")
            //            self.profleEditViewModel.password = textField.text!
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.tag)
        print(textField.text)
        
        switch textField.tag {
        case 0:
            self.profleEditViewModel.firstName = textField.text!
            return
        case 1:
            self.profleEditViewModel.lastName = textField.text!
            return
        case 2:
            self.profleEditViewModel.mobileNumber = textField.text!
            return
        case 3:
            self.profleEditViewModel.email = textField.text!
            return
        default:
            print("Meant to be Password Editing area")
            //            self.profleEditViewModel.password = textField.text!
            return
        }
    }
    
}

