

import Foundation
import UITextField_Shake
import Big_Neon_UI

internal class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate var welcomeLabelTopConstraint: NSLayoutConstraint?
    internal let createAccountViewModel: AccountViewModel = AccountViewModel()
    
    private var headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Create your account"
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
        textField.textFieldType = .signUpPassword
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
        self.setupKeyboardObservers()
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
        view.addSubview(nextButton)
        nextButton.addSubview(loadingIndicatorView)
        
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        welcomeLabelTopConstraint = headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 36)
        welcomeLabelTopConstraint?.isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        emailTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emailTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailTextView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 48).isActive = true
        emailTextView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        passwordTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        passwordTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        passwordTextView.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: 12).isActive = true
        passwordTextView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
        nextButton.topAnchor.constraint(equalTo: passwordTextView.bottomAnchor, constant: 35).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loadingIndicatorView.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
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
        self.nextButton.isEnabled = false
        self.nextButton.setTitle("", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func enableView() {
        self.loadingIndicatorView.stopAnimating()
        self.emailTextView.authTextField.isEnabled = true
        self.passwordTextView.authTextField.isEnabled = true
        self.nextButton.isEnabled = true
        self.nextButton.setTitle("Let's do this", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc internal func handleDone() {
        
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
            self.passwordTextView.textFieldError = .emptySignUpPassword
            return
        }
        
        if password.characters.count < 7 {
            self.passwordTextView.textFieldError = .lessCharacters
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
    
}

extension CreateAccountViewController {
    
    fileprivate func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        UIView.animate(withDuration: 0.32, animations: {
            if isKeyboardShowing == true {
                guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
                    return
                }
                let keyboardHeight = keyboardSize.height
                self.headerLabel.layer.opacity = 0.0
                self.welcomeLabelTopConstraint?.constant = -20.0
            } else {
                self.headerLabel.layer.opacity = 1.0
                self.welcomeLabelTopConstraint?.constant = 36.0
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignTextFields()
    }
    
    fileprivate func resignTextFields() {
        self.emailTextView.authTextField.resignFirstResponder()
        self.passwordTextView.resignFirstResponder()
    }

}
