

import Foundation
import UITextField_Shake
import Big_Neon_UI

internal class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate var buttonBottomAnchorConstraint: NSLayoutConstraint?
    internal let createAccountViewModel: AccountViewModel = AccountViewModel()
    
    private var headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Create your account"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailTextField: BrandTextField = {
        let textField = BrandTextField()
        textField.layer.cornerRadius = 4.0
        textField.autocapitalizationType = .none
        textField.placeholder = "Email Address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var passwordTextField: BrandTextField = {
        let textField = BrandTextField()
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 4.0
        textField.autocapitalizationType = .none
        textField.placeholder = "password (atleast 6 characters)"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var nextButton: GradientBrandButton = {
        let button = GradientBrandButton()
        button.setTitle("Let's do this", for: UIControl.State.normal)
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: UIBarButtonItem.Style.done, target: self, action: #selector(handleBack))
    }
    
    @objc private func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureView() {
        view.addSubview(headerLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        nextButton.addSubview(loadingIndicatorView)
        
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
        emailTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 48).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 25).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
        nextButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 35).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loadingIndicatorView.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        loadingIndicatorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loadingIndicatorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    fileprivate func setupDelegates() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    internal func textFieldShake(_ textField: UITextField) {
        textField.shake(3, withDelta: 6, speed: 0.08)
    }
    
    private func disableView() {
        self.loadingIndicatorView.startAnimating()
        self.emailTextField.isEnabled = false
        self.passwordTextField.isEnabled = false
        self.nextButton.isEnabled = false
        self.nextButton.setTitle("", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func enableView() {
        self.loadingIndicatorView.stopAnimating()
        self.emailTextField.isEnabled = false
        self.passwordTextField.isEnabled = false
        self.nextButton.isEnabled = true
        self.nextButton.setTitle("Let's do this", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc internal func handleDone() {
        
        guard let email = self.emailTextField.text else {
            self.textFieldShake(self.emailTextField)
            return
        }
        
        guard let password = self.passwordTextField.text else {
            self.textFieldShake(self.passwordTextField)
            return
        }
        
        if email.isEmpty == true {
            self.textFieldShake(self.emailTextField)
            return
        }
        
        if password.isEmpty == true {
            self.textFieldShake(self.passwordTextField)
            return
        }
        
        if password.characters.count < 7 {
            print("Password should be more than 6 characters")
            self.textFieldShake(self.passwordTextField)
            return
        }
        
        //  Check Validity of email
        if email.isValidEmailAddress == false {
            self.textFieldShake(self.emailTextField)
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
                self.navigationController?.pushViewController(NamesViewController(), animated: true)
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
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
}


