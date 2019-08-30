

import UIKit
import Big_Neon_UI
import SafariServices

// MARK:  magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar
// MARK: internal is default access level - not need for explicit definition

final class WelcomeViewController: UIViewController {
    
    private var loginButtonBottomConstraint: NSLayoutConstraint?
    private var getStartedButtonBottomConstraint: NSLayoutConstraint?
    
    var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "onboarding_Background")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_logoImage")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var getStartedButton: BrandButton = {
        let button = BrandButton()
        button.addTarget(self, action: #selector(handleCreateAccount), for: UIControl.Event.touchUpInside)
        button.setTitle("Get Started", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginButton: BrandButton = {
        let button = BrandButton()
        button.addTarget(self, action: #selector(handleLogin), for: UIControl.Event.touchUpInside)
        button.setTitle("Login to your Account", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

//    private lazy var loginButton: UIButton = {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(handleLogin), for: UIControl.Event.touchUpInside)
//        button.backgroundColor = UIColor.clear
//        button.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
//        button.layer.borderWidth = 2.0
//        button.layer.cornerRadius = 3.0
//        button.setTitle("Login To Your Account", for: UIControl.State.normal)
//        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControl.State.normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.configureView()
        self.perform(#selector(animateButtons), with: self, afterDelay: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.configureNavBar()
    }
    
    @objc private func animateButtons() {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            self.loginButtonBottomConstraint?.constant = -60
            self.getStartedButtonBottomConstraint?.constant = -140
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func configureNavBar() {
        self.navigationClearBar()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.brandPrimary
    }
    
    private func configureView() {
        self.view.addSubview(backgroundImage)
        self.view.addSubview(logoImage)
        self.view.addSubview(loginButton)
        //  self.view.addSubview(getStartedButton)
        
        self.backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.logoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
        self.logoImage.heightAnchor.constraint(equalToConstant: 160).isActive = true
        self.logoImage.widthAnchor.constraint(equalToConstant: 120).isActive = true

        self.loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        self.loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        self.loginButtonBottomConstraint = self.loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 200)
        self.loginButtonBottomConstraint?.isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        /*
        self.getStartedButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        self.getStartedButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        self.getStartedButtonBottomConstraint = getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 200)
        self.getStartedButtonBottomConstraint?.isActive = true
        self.getStartedButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        */
        
    }
    
    @objc private func handleCreateAccount() {
        buttonBounceAnimation(buttonPressed: self.getStartedButton)
        self.navigationController?.pushViewController(CreateAccountViewController(), animated: true)
    }
    
    @objc private func handleLogin() {
        buttonBounceAnimation(buttonPressed: self.loginButton)
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
}
