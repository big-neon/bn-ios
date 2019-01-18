


import Foundation
import UITextField_Shake
import Big_Neon_UI

internal class NamesViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate var buttonBottomAnchorConstraint: NSLayoutConstraint?
    internal let createAccountViewModel: AccountViewModel = AccountViewModel()
    
    private var headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Make your tickets… yours."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var firstNameTextView: AuthenticationTextView = {
        let textField = AuthenticationTextView()
        textField.textFieldType = .firstName
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var lastNameTextView: AuthenticationTextView = {
        let textField = AuthenticationTextView()
        textField.textFieldType = .lastName
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var nextButton: GradientBrandButton = {
        let button = GradientBrandButton()
        button.setTitle("All Done", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleDone), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal let loadingIndicatorView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .white
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.configureNavBar()
        self.setupDelegates()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.configureNavBar()
    }
    
    private func configureNavBar() {
        self.navigationNoLineBar()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: #selector(handleNothing))
    }
    
    @objc private func handleNothing() {
    }
    
    private func configureView() {
        view.addSubview(headerLabel)
        view.addSubview(firstNameTextView)
        view.addSubview(lastNameTextView)
        view.addSubview(nextButton)
        nextButton.addSubview(loadingIndicatorView)
        
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        firstNameTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        firstNameTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        firstNameTextView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 48).isActive = true
        firstNameTextView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        lastNameTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lastNameTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lastNameTextView.topAnchor.constraint(equalTo: firstNameTextView.bottomAnchor, constant: 12).isActive = true
        lastNameTextView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
        nextButton.topAnchor.constraint(equalTo: lastNameTextView.bottomAnchor, constant: 35).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loadingIndicatorView.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        loadingIndicatorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loadingIndicatorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    fileprivate func setupDelegates() {
        self.firstNameTextView.authTextField.delegate = self
        self.lastNameTextView.authTextField.delegate = self
    }
    
    private func disableView() {
        self.loadingIndicatorView.startAnimating()
        self.firstNameTextView.authTextField.isEnabled = false
        self.lastNameTextView.authTextField.isEnabled = false
        self.nextButton.isEnabled = false
        self.nextButton.setTitle("", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func enableView() {
        self.loadingIndicatorView.stopAnimating()
        self.firstNameTextView.authTextField.isEnabled = true
        self.lastNameTextView.authTextField.isEnabled = true
        self.nextButton.isEnabled = true
        self.nextButton.setTitle("Let's do this", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc internal func handleDone() {
        
        guard let name = self.firstNameTextView.authTextField.text else {
            self.firstNameTextView.textFieldError = TextFieldError.invalidName
            return
        }
        
        guard let lastName = self.lastNameTextView.authTextField.text else {
            self.lastNameTextView.textFieldError = TextFieldError.invalidSurname
            return
        }
        
        if name.isEmpty == true {
            self.firstNameTextView.textFieldError = TextFieldError.emptyName
            return
        }
        
        if lastName.isEmpty == true {
            self.lastNameTextView.textFieldError = TextFieldError.emptySurname
            return
        }
        
        self.resignTextFields()
//        self.disableView()
//        self.createAccountViewModel.createAccount(email: name, password: lastName) { (success) in
//            DispatchQueue.main.async {
//                if success == false {
//                    self.enableView()
//                    return
//                }
//                self.enableView()
//                self.handleShowHome()
//            }
//        }
        self.handleShowHome()
    }
    
    @objc private func handleShowHome() {
        let tabBarVC = TabBarController()
        tabBarVC.modalTransitionStyle = .flipHorizontal
        self.present(tabBarVC, animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignTextFields()
    }
    
    fileprivate func resignTextFields() {
        self.firstNameTextView.authTextField.resignFirstResponder()
        self.lastNameTextView.authTextField.resignFirstResponder()
    }
    
}

