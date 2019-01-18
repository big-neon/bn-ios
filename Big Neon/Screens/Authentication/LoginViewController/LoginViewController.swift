


import Foundation
import UITextField_Shake
import Big_Neon_UI

internal class LoginViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate var buttonBottomAnchorConstraint: NSLayoutConstraint?
    internal let createAccountViewModel: AccountViewModel = AccountViewModel()
    
    private var headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Welcome Back!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextView: AuthenticationTextView = {
        let textField = AuthenticationTextView()
        textField.textFieldType = .email
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var passwordTextView: AuthenticationTextView = {
        let textField = AuthenticationTextView()
        textField.textFieldType = .loginPassword
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var loginButton: GradientBrandButton = {
        let button = GradientBrandButton()
        button.setTitle("Login to your account", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleLogin), for: UIControl.Event.touchUpInside)
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: UIBarButtonItem.Style.done, target: self, action: #selector(handleBack))
    }
    
    @objc private func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureView() {
        view.addSubview(headerLabel)
        view.addSubview(emailTextView)
        view.addSubview(passwordTextView)
        view.addSubview(loginButton)
        loginButton.addSubview(loadingIndicatorView)
        
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        emailTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emailTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailTextView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 48).isActive = true
        emailTextView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        passwordTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        passwordTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        passwordTextView.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: 12).isActive = true
        passwordTextView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26).isActive = true
        loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextView.bottomAnchor, constant: 35).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loadingIndicatorView.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        loadingIndicatorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loadingIndicatorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    fileprivate func setupDelegates() {
        self.emailTextView.authTextField.delegate = self
        self.passwordTextView.authTextField.delegate = self
    }
    
    internal func textFieldShake(_ textField: UITextField) {
        textField.shake(3, withDelta: 6, speed: 0.08)
    }
    
    private func disableView() {
        self.loadingIndicatorView.startAnimating()
        self.emailTextView.authTextField.isEnabled = false
        self.passwordTextView.authTextField.isEnabled = false
        self.loginButton.isEnabled = false
        self.loginButton.setTitle("", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func enableView() {
        self.loadingIndicatorView.stopAnimating()
        self.emailTextView.authTextField.isEnabled = false
        self.passwordTextView.authTextField.isEnabled = false
        self.loginButton.isEnabled = true
        self.loginButton.setTitle("Login to your account", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc internal func handleLogin() {
        
        guard let email = self.emailTextView.authTextField.text else {
            self.emailTextView.textFieldError = .invalidEmail
            return
        }
        
        if email.isEmpty == true {
            self.emailTextView.textFieldError = .emptyEmail
            return
        }
        
        if email.isValidEmailAddress == false {
            self.emailTextView.textFieldError = .invalidEmail
            return
        }
        
        guard let password = self.passwordTextView.authTextField.text else {
            self.passwordTextView.textFieldError = .invalidPassword
            return
        }
        
        if password.isEmpty == true {
            self.passwordTextView.textFieldError = .invalidPassword
            return
        }
        
        self.resignTextFields()
        self.disableView()
        self.createAccountViewModel.createAccount(email: email, password: password) { (success) in
            DispatchQueue.main.async {
                if success == false {
                    self.enableView()
                    return
                }
                self.enableView()
                self.handleShowHome()
            }
        }
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
        self.emailTextView.authTextField.resignFirstResponder()
        self.passwordTextView.authTextField.resignFirstResponder()
    }
    
}


