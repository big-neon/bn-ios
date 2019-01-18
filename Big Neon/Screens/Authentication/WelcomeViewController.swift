

import UIKit
import Big_Neon_UI
import SafariServices

final class WelcomeViewController: UIViewController {
    
    internal var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "onboarding_Background")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_logoImage")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var getStartedButton: GradientBrandButton = {
        let button = GradientBrandButton()
        button.addTarget(self, action: #selector(handleCreateAccount), for: UIControl.Event.touchUpInside)
        button.setTitle("Get Started", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var loginButton: GradientBrandButton = {
        let button = GradientBrandButton()
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 3.0
        button.setTitle("Login To Your Account", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.configureNavBar()
    }
    
    private func configureNavBar() {
        self.navigationClearBar()
        self.navigationController?.navigationBar.tintColor = UIColor.brandPrimary
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        UIApplication.shared.statusBarView?.tintColor = UIColor.white
    }
    
    private func configureView() {
        self.view.addSubview(backgroundImage)
        self.view.addSubview(logoImage)
        self.view.addSubview(loginButton)
        self.view.addSubview(getStartedButton)
        
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
        self.loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        self.getStartedButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        self.getStartedButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        self.getStartedButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -18).isActive = true
        self.getStartedButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
    }
    
    @objc private func handleCreateAccount() {
        self.navigationController?.pushViewController(CreateAccountViewController(), animated: true)
    }
    
}
