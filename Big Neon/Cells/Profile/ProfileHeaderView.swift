
import UIKit
import PINRemoteImage
import Big_Neon_Core

final public class ProfileHeaderView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    public var user: User? {
        didSet {
            guard let user = self.user else {
                return
            }
            
            self.userNameLabel.text = "\(user.firstName ?? "-") \(user.lastName ?? "-")"
            if let email = user.email {
                self.userEmailLabel.text = email.uppercased()
            }
            
            if let profilePicURL = user.profilePicURL   {
                profileImageView.pin_setImage(from: URL(string: profilePicURL), placeholderImage: UIImage(named: "ic_emptyProfileImage"))
            }
        }
    }
    
    public lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadProfileImage)))
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.cornerRadius = 29.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        
        imageView.image = UIImage(named: "ic_QRCode")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowRadius = 5.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var emailIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_message")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var userEmailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 0.8
        self.configureHeaderGradient()
        self.configureView()
        
    }
    
    private func configureView() {
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(emailIconImageView)
        addSubview(userEmailLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 210).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 58).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 58).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 9).isActive = true
        userNameLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        emailIconImageView.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor).isActive = true
        emailIconImageView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10).isActive = true
        emailIconImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        emailIconImageView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        userEmailLabel.leftAnchor.constraint(equalTo: emailIconImageView.rightAnchor, constant: 10).isActive = true
        userEmailLabel.rightAnchor.constraint(equalTo: userNameLabel.rightAnchor).isActive = true
        userEmailLabel.centerYAnchor.constraint(equalTo: emailIconImageView.centerYAnchor).isActive = true
        userEmailLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    @objc private func uploadProfileImage() {
        self.delegate?.handleUploadImage()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeaderGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: 180)
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        let colors: [CGColor] = [UIColor(red: 84.0/255.0, green: 145.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor, UIColor(red: 222.0/255.0, green: 65.0/255.0, blue: 152.0/255.0, alpha: 1.0).cgColor]
        let location = [0.0, 1.0]
        gradient.colors = colors
        gradient.isOpaque = true
        gradient.locations = location as [NSNumber]
        self.layer.addSublayer(gradient)
    }
}
