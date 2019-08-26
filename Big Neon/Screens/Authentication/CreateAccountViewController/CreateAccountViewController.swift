

import Foundation
import UITextField_Shake
import Big_Neon_UI

// MARK:  magic numbers... consider using layout/config class/enum
// MARK: use abbreviation / syntax sugar

internal class CreateAccountViewController: BaseViewController, UITextFieldDelegate {
    
    var welcomeLabelTopConstraint: NSLayoutConstraint?
    var showPasswordValue = false
    let createAccountViewModel: AccountViewModel = AccountViewModel()
    
    lazy var headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Create your account"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var emailTextView: AuthenticationTextView = {
        let textField = AuthenticationTextView()
        textField.textFieldType = .email
        textField.authTextField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextView: AuthenticationTextView = {
        let textField = AuthenticationTextView()
        textField.authTextField.keyboardType = .default
        textField.textFieldType = .signUpPassword
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var nextButton: BrandButton = {
        let button = BrandButton()
        button.spinnerColor = .white
        button.setTitle("Let's do this", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleDone), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var showPassword: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.brandPrimary, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        button.setTitle("SHOW", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleShowPassword), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureNavBar()
        setupDelegates()
        configureView()
        setupKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.configureNavBar()
    }
    
    private func configureNavBar() {
        guard let navigationController = self.navigationController else {
            return
        }
        self.navigationNoLineBar()
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.navigationBar.tintColor = UIColor.black
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.backgroundColor = UIColor.white
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: UIBarButtonItem.Style.done, target: self, action: #selector(handleBack))
    }
    
    private func configureView() {
        view.addSubview(headerLabel)
        view.addSubview(emailTextView)
        view.addSubview(passwordTextView)
        passwordTextView.addSubview(showPassword)
        view.addSubview(nextButton)
        
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
        
        showPassword.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        showPassword.topAnchor.constraint(equalTo: passwordTextView.topAnchor, constant: -16).isActive = true
        showPassword.bottomAnchor.constraint(equalTo: passwordTextView.bottomAnchor).isActive = true
        showPassword.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    fileprivate func setupDelegates() {
        self.emailTextView.authTextField.delegate = self
        self.passwordTextView.authTextField.delegate = self
    }
    
    internal func textFieldShake(_ textField: UITextField) {
        textField.shake(3, withDelta: 6, speed: 0.08)
    }
    
    private func disableView() {
        self.emailTextView.authTextField.isEnabled = false
        self.passwordTextView.authTextField.isEnabled = false
        self.nextButton.isEnabled = false
        self.nextButton.setTitle("", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func enableView() {
        self.emailTextView.authTextField.isEnabled = true
        self.passwordTextView.authTextField.isEnabled = true
        self.nextButton.isEnabled = true
        self.nextButton.setTitle("Let's do this", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc internal func handleShowPassword() {
        buttonBounceAnimation(buttonPressed: self.showPassword)
        self.showPasswordValue = !self.showPasswordValue
        self.passwordTextView.authTextField.isSecureTextEntry = self.showPasswordValue
        if self.showPasswordValue == false {
            self.showPassword.setTitle("HIDE", for: UIControl.State.normal)
        } else {
            self.showPassword.setTitle("SHOW", for: UIControl.State.normal)
        }
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
        self.nextButton.startAnimation()

        self.createAccountViewModel.createAccount(email: email, password: password) { (success, errorString) in
            DispatchQueue.main.async {

                if errorString != nil {
                    self.nextButton.stopAnimation(animationStyle: .shake,
                                                  revertAfterDelay: 3.0,
                                                  completion: {
                                                    self.showFeedback(message: errorString!)
                                                    self.enableView()
                    })
                    return
                }

                if success == false {
                    self.nextButton.stopAnimation(animationStyle: .shake,
                                                  revertAfterDelay: 3.0,
                                                  completion: {
                                                    //MARK: do not use explicite unwraping,
                                                    // previous guard is not covering errorString
                                                    self.showFeedback(message: errorString!)
                                                    self.enableView()
                    })
                    return
                }
                
                self.nextButton.stopAnimation(animationStyle: .normal,
                                              revertAfterDelay: 3.0,
                                              completion: {
                                                self.enableView()
                                                self.navigationController?.pushViewController(NamesViewController(), animated: true)
                })
                
            }
        }
    }
    
}


// MARK: setupKeyboardObservers() and handleKeyboardNotification(notification: NSNotification) should be extension of baseViewCOntroller
// or some other base class (DRY)
// repetetive code 
extension CreateAccountViewController {
    
    fileprivate func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        UIView.animate(withDuration: 0.32, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
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
