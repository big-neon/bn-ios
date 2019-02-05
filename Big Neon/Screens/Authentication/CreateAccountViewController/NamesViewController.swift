

import Foundation
import UITextField_Shake
import Big_Neon_UI

internal class NamesViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate var headerLabelTopConstraint: NSLayoutConstraint?
    internal let createAccountViewModel: AccountViewModel = AccountViewModel()
    
    internal lazy var errorFeedback: FeedbackSystem = {
        let feedback = FeedbackSystem()
        return feedback
    }()
    
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
    
    fileprivate lazy var doneButton: BrandButton = {
        let button = BrandButton()
        button.spinnerColor = .white
        button.setTitle("All Done", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleDone), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        view.addSubview(doneButton)
        
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        self.headerLabelTopConstraint = headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 36)
        self.headerLabelTopConstraint?.isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        firstNameTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        firstNameTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        firstNameTextView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 48).isActive = true
        firstNameTextView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        lastNameTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lastNameTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lastNameTextView.topAnchor.constraint(equalTo: firstNameTextView.bottomAnchor, constant: 12).isActive = true
        lastNameTextView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        doneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26).isActive = true
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
        doneButton.topAnchor.constraint(equalTo: lastNameTextView.bottomAnchor, constant: 35).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setupDelegates() {
        self.firstNameTextView.authTextField.delegate = self
        self.lastNameTextView.authTextField.delegate = self
    }
    
    private func disableView() {
        self.firstNameTextView.authTextField.isEnabled = false
        self.lastNameTextView.authTextField.isEnabled = false
        self.doneButton.isEnabled = false
        self.doneButton.setTitle("", for: UIControl.State.normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func enableView() {
        self.firstNameTextView.authTextField.isEnabled = true
        self.lastNameTextView.authTextField.isEnabled = true
        self.doneButton.isEnabled = true
        self.doneButton.setTitle("Let's do this", for: UIControl.State.normal)
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
        
        self.doneButton.startAnimation()
        self.resignTextFields()
        self.disableView()
        self.createAccountViewModel.insert(name: name, lastName: lastName) { (error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.doneButton.stopAnimation(animationStyle: .shake,
                                                  revertAfterDelay: 1.0,
                                                  completion: {
                                                    self.showFeedback(message: (error?.localizedDescription)!)
                                                    self.enableView()
                    })
                    return
                }
                
                self.doneButton.stopAnimation(animationStyle: .expand,
                                              revertAfterDelay: 1.0,
                                              completion: {
                                                self.enableView()
                                                self.handleShowHome()
                })
            }
        }
    }
    
    private func showFeedback(message: String) {
        if let window = UIApplication.shared.keyWindow {
            self.errorFeedback.showFeedback(backgroundColor: UIColor.brandBlack,
                                            feedbackLabel: message,
                                            feedbackLabelColor: UIColor.white,
                                            durationOnScreen: 3.0,
                                            currentView: window,
                                            showsBackgroundGradient: true,
                                            isAboveTabBar: false)
        }
    }
    
    @objc private func handleShowHome() {
        let tabBarVC = TabBarController()
        self.present(tabBarVC, animated: true, completion: nil)
    }
    
}


extension NamesViewController {
    
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
                self.headerLabelTopConstraint?.constant = -20.0
            } else {
                self.headerLabel.layer.opacity = 1.0
                self.headerLabelTopConstraint?.constant = 36.0
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignTextFields()
    }
    
    fileprivate func resignTextFields() {
        self.firstNameTextView.authTextField.resignFirstResponder()
        self.lastNameTextView.resignFirstResponder()
    }
    
}
