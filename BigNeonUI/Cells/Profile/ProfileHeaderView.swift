
import UIKit

final public class ProfileHeaderView: UIView {
    
    public let profileHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_emptyProfileImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.cornerRadius = 29.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_QRCode")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowRadius = 5.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Kook McDropin"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let emailIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_message")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let userEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "kookmcdropz@gmail.com".uppercased()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 0.8
        self.configureView()
        self.configureHeaderGradient()
    }
    
    private func configureView() {
        self.addSubview(profileHeaderView)
        self.addSubview(profileImageView)
        self.addSubview(qrCodeImageView)
        self.addSubview(userNameLabel)
        self.addSubview(emailIconImageView)
        self.addSubview(userEmailLabel)
        
        self.profileHeaderView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.profileHeaderView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.profileHeaderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.profileHeaderView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        self.profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: 29).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 58).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 58).isActive = true
        
        self.qrCodeImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        self.qrCodeImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        self.qrCodeImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.qrCodeImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true

        self.userNameLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        self.userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 9).isActive = true
        self.userNameLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.userNameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.emailIconImageView.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor).isActive = true
        self.emailIconImageView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10).isActive = true
        self.emailIconImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        self.emailIconImageView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        self.userEmailLabel.leftAnchor.constraint(equalTo: emailIconImageView.rightAnchor, constant: 10).isActive = true
        self.userEmailLabel.rightAnchor.constraint(equalTo: userNameLabel.rightAnchor).isActive = true
        self.userEmailLabel.centerYAnchor.constraint(equalTo: emailIconImageView.centerYAnchor).isActive = true
        self.userEmailLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeaderGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = profileHeaderView.frame
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.55)
        let colors: [CGColor] = [UIColor(white: 1.0, alpha: 1.0).cgColor, UIColor(white: 1.0, alpha: 0.4).cgColor, UIColor(white: 1.0, alpha: 0.0).cgColor]
        let location = [0.0, 0.6, 0.9]
        gradient.colors = colors
        gradient.isOpaque = true
        gradient.locations = location as [NSNumber]
        profileHeaderView.layer.addSublayer(gradient)
    }
}
