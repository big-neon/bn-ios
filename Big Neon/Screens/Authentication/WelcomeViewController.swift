

import UIKit
import SafariServices

final class WelcomeViewController: UIViewController {
    
    internal var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.brandBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.brandBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
//    internal let headingLabel: BrandTitleLabel = {
//        let label = BrandTitleLabel()
//        label.textAlignment = .center
//        label.text = "City One"
//        label.font = UIFont.titleStyle.withSize(30)
//        label.textColor = UIColor.brandPrimary
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    internal let subHeadingLabel: BrandLargeLabel = {
//        let label = BrandLargeLabel()
//        label.textColor = UIColor.brandMediumGrey
//        label.numberOfLines = 2
//        label.text = "Ready to save time and money on your Commute?"
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private lazy var getStartedButton: BrandButton = {
//        let button = BrandButton()
//        button.setTitle("Login with Phone Number", for: UIControlState.normal)
//        button.addTarget(self, action: #selector(handleRegister), for: UIControlEvents.touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    private lazy var facebookButton: BrandButton = {
//        let button = BrandButton()
//        button.backgroundColor = UIColor(red: 60/255, green: 90/255, blue: 153/255, alpha: 1.0)
//        button.setTitle("Continue with Facebook", for: UIControlState.normal)
//        button.addTarget(self, action: #selector(handleFacebookRegistration), for: UIControlEvents.touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
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
        self.navigationNoLineBar()
        self.navigationController?.navigationBar.tintColor = UIColor.brandPrimary
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
    }
    
    private func configureView() {
        self.view.addSubview(backgroundImage)
        //        self.view.addSubview(facebookButton)
//        self.view.addSubview(termsButton)
//        self.view.addSubview(backgroundImage)
//        self.view.addSubview(headingLabel)
//        self.view.addSubview(subHeadingLabel)
        
        self.backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
//        self.headingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        self.headingLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
//        self.headingLabel.bottomAnchor.constraint(equalTo: subHeadingLabel.topAnchor, constant: -24).isActive = true
//        self.headingLabel.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
//
//        self.backgroundImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        self.logoImage.bottomAnchor.constraint(equalTo: headingLabel.topAnchor, constant: -42).isActive = true
//        self.backgroundImage.heightAnchor.constraint(equalToConstant: 104).isActive = true
//        self.backgroundImage.widthAnchor.constraint(equalToConstant: 104).isActive = true
//
//        self.termsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        self.termsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
//        self.termsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18).isActive = true
//        self.termsButton.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
//
//        self.getStartedButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
//        self.getStartedButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
//        self.getStartedButton.bottomAnchor.constraint(equalTo: termsButton.topAnchor, constant: -60).isActive = true
//        self.getStartedButton.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        
    }
    
}
