

import Foundation
import UITextField_Shake
import BigeonUI

internal class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate var buttonBottomAnchorConstraint: NSLayoutConstraint?
    internal let onboardingViewModel: OnboardingViewModel = OnboardingViewModel()
    
    private var headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Create your account"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailTextField: BrandTextField = {
        let textField = BrandTextField()
        textField.layer.cornerRadius = 6.0
        textField.autocapitalizationType = .none
        textField.placeholder = "Email Address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var passwordTextField: BrandTextField = {
        let textField = BrandTextField()
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 16.0
        textField.autocapitalizationType = .none
        textField.placeholder = "password (atleast 6 characters)"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var nextButton: BrandButton = {
        let button = BrandButton()
        button.setTitle("Let's do this", for: UIControlState.normal)
//        button.addTarget(self, action: #selector(handleDone), for: UIControlEvents.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal let loadingIndicatorView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.activityIndicatorViewStyle = .white
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        BusinessService.shared.analytics.setScreen(withName: ScreenName.OnboardingName.rawValue)
    }
    
    private func configureNavBar() {
        self.navigationNoLineBar()
        self.navigationController?.navigationBar.tintColor = UIColor.brandPrimary
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleNothing))
    }
    
    @objc private func handleNothing() {
        
    }
    
    private func configureView() {
        view.addSubview(headerLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
//        nextButton.addSubview(loadingIndicatorView)
        
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        emailTextField.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 48).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 3).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
//        loadingIndicatorView.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).isActive = true
//        loadingIndicatorView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
//        loadingIndicatorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        loadingIndicatorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    fileprivate func setupDelegates() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @nonobjc internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.becomeFirstResponder()
        return false
    }
    
    internal func textFieldShake(_ textField: UITextField) {
        textField.shake(3, withDelta: 6, speed: 0.08)
    }
    
    private func disableView() {
        self.loadingIndicatorView.startAnimating()
        self.nameTextField.isEnabled = false
        self.surnameTextField.isEnabled = false
        self.nextButton.isEnabled = false
        self.nextButton.setTitle("", for: UIControlState.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func enableView() {
        self.loadingIndicatorView.stopAnimating()
        self.nameTextField.isEnabled = false
        self.surnameTextField.isEnabled = false
        self.nextButton.isEnabled = true
        self.nextButton.setTitle("Done", for: UIControlState.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc internal func handleDone() {
        
        if self.nameTextField.text?.isEmpty == true {
            self.textFieldShake(self.nameTextField)
            return
        }
        
        if self.surnameTextField.text?.isEmpty == true {
            self.textFieldShake(self.surnameTextField)
            return
        }
        
        guard let name = self.nameTextField.text else {
            self.textFieldShake(self.nameTextField)
            return
        }
        
        
        guard let surname = surnameTextField.text else {
            self.textFieldShake(self.surnameTextField)
            return
        }
        
        self.resignTextFields()
        self.disableView()
        self.onboardingViewModel.insert(name: name, surname: surname) { (success) in
            if success == false {
                self.enableView()
                return
            }
            self.enableView()
            self.navigationController?.push(DailyRouteViewController())
        }
    }
}

extension NamesViewController {
    
    fileprivate func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
        UIView.animate(withDuration: 0.32, animations: {
            if isKeyboardShowing == true {
                guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
                    return
                }
                let keyboardHeight = keyboardSize.height
                self.buttonBottomAnchorConstraint?.constant = -keyboardHeight - 20.0
            } else {
                self.buttonBottomAnchorConstraint?.constant = -24
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignTextFields()
    }
    
    fileprivate func resignTextFields() {
        self.nameTextField.resignFirstResponder()
        self.surnameTextField.resignFirstResponder()
    }
    
}


