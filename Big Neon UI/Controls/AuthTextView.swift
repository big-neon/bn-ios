

import UIKit
import UITextField_Shake

public enum TextFieldType {
    case email
    case signUpPassword
    case loginPassword
    case firstName
    case lastName
}

public enum TextFieldError: String {
    case invalidEmail = "Please enter a valid email address"
    case emptyEmail = "Please enter your email address"
    case invalidPassword = "Please enter a valid password"
    case emptySignUpPassword = "Please enter a password"
    case lessCharacters = "Your password needs to have atleast 6 characters"
    case defaultError = "Incorrect Text Entered"
}

public class AuthenticationTextView: UIView {
    
    public var textFieldType: TextFieldType? {
        didSet {
            guard let textType = self.textFieldType else {
                return
            }
            
            self.authTextField.autocapitalizationType = .none
            switch textType {
            case .email:
                self.authTextField.placeholder = "Email Address"
            case .signUpPassword:
                self.authTextField.isSecureTextEntry = true
                self.authTextField.placeholder = "Create Password (atleast 6 characters)"
            case .loginPassword:
                self.authTextField.isSecureTextEntry = true
                self.authTextField.placeholder = "Enter Password)"
            case .firstName:
                self.authTextField.placeholder = "First Name"
            case .lastName:
                self.authTextField.placeholder = "Last Name"
            }
        }
    }
    
    public var textFieldError: TextFieldError? {
        didSet {
            guard let errorType = self.textFieldError else {
                return
            }
            
            self.authTextField.layer.borderColor = UIColor.brandError.cgColor
            self.authTextField.layer.borderWidth = 1.0
            self.textFieldShake(authTextField)
            self.errorLabel.text = errorType.rawValue
            self.perform(#selector(restoreView), with: self, afterDelay: 2.4)
        }
    }
    
    @objc private func restoreView() {
        UIView.animate(withDuration: 0.4) {
            self.authTextField.layer.borderColor = UIColor.clear.cgColor
            self.authTextField.layer.borderWidth = 0.0
            self.errorLabel.text = ""
        }
        
    }
    
    private func textFieldShake(_ textField: UITextField) {
        textField.shake(3, withDelta: 6, speed: 0.08)
    }
    
    public lazy var authTextField: BrandTextField = {
        let textField = BrandTextField()
        textField.layer.cornerRadius = 4.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandError
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override func layoutSubviews() {
        self.roundCorners([.topLeft, .topRight, .bottomRight], radius: 5.0)
        self.layer.masksToBounds = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(authTextField)
        self.addSubview(errorLabel)
        
        authTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 26).isActive = true
        authTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -26).isActive = true
        authTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        authTextField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        errorLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 26).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -26).isActive = true
        errorLabel.topAnchor.constraint(equalTo: authTextField.bottomAnchor, constant: 4).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 14.0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
