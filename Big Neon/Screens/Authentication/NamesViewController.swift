


import Foundation
import UITextField_Shake
import BigNeonUI

internal class NamesAccountViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate var buttonBottomAnchorConstraint: NSLayoutConstraint?
    internal let createAccountViewModel: CreateAccountViewModel = CreateAccountViewModel()
    
    private var headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Make your tickets… yours."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var firstNameTextField: BrandTextField = {
        let textField = BrandTextField()
        textField.layer.cornerRadius = 4.0
        textField.autocapitalizationType = .none
        textField.placeholder = "First Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var surnameTextField: BrandTextField = {
        let textField = BrandTextField()
        textField.layer.cornerRadius = 4.0
        textField.autocapitalizationType = .none
        textField.placeholder = "Last Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var nextButton: GradientBrandButton = {
        let button = GradientBrandButton()
        button.setTitle("All Done", for: UIControl.State.normal)
//        button.addTarget(self, action: #selector(handleDone), for: UIControl.Event.touchUpInside)
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
        view.addSubview(firstNameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(nextButton)
        nextButton.addSubview(loadingIndicatorView)
        
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        firstNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26).isActive = true
        firstNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 48).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        surnameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26).isActive = true
        surnameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
        surnameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 25).isActive = true
        surnameTextField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
        nextButton.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 35).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loadingIndicatorView.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        loadingIndicatorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loadingIndicatorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    fileprivate func setupDelegates() {
        self.firstNameTextField.delegate = self
        self.surnameTextField.delegate = self
    }
    
    internal func textFieldShake(_ textField: UITextField) {
        textField.shake(3, withDelta: 6, speed: 0.08)
    }
    
    private func disableView() {
        self.loadingIndicatorView.startAnimating()
        self.firstNameTextField.isEnabled = false
        self.surnameTextField.isEnabled = false
        self.nextButton.isEnabled = false
        self.nextButton.setTitle("", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func enableView() {
        self.loadingIndicatorView.stopAnimating()
        self.firstNameTextField.isEnabled = false
        self.surnameTextField.isEnabled = false
        self.nextButton.isEnabled = true
        self.nextButton.setTitle("Let's do this", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc internal func handleDone() {
        
        guard let email = self.firstNameTextField.text else {
            self.textFieldShake(self.firstNameTextField)
            return
        }
        
        guard let password = self.surnameTextField.text else {
            self.textFieldShake(self.surnameTextField)
            return
        }
        
        if email.isEmpty == true {
            self.textFieldShake(self.firstNameTextField)
            return
        }
        
        if password.isEmpty == true {
            self.textFieldShake(self.surnameTextField)
            return
        }
        
        //  Check Validity of email
        if email.isValidEmailAddress == false {
            self.textFieldShake(self.firstNameTextField)
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
        self.firstNameTextField.resignFirstResponder()
        self.surnameTextField.resignFirstResponder()
    }
    
}


