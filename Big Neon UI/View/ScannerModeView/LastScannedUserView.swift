

import UIKit

public class LastScannedUserView: UIView {
    
    public lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 17.0
        imageView.backgroundColor = UIColor.brandBackground
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Anna Behrensmeyer"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "General Admission"
        label.textColor = UIColor.brandBackground
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var ticketScanStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_checkedIn_tick")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.layer.cornerRadius = 34.0
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(userImageView)
        self.addSubview(userNameLabel)
        self.addSubview(ticketTypeLabel)
        self.addSubview(ticketScanStateImageView)
        
        userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        ticketScanStateImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ticketScanStateImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        ticketScanStateImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        ticketScanStateImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true

        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: ticketScanStateImageView.leftAnchor, constant: -12).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true

        ticketTypeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2).isActive = true
        ticketTypeLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        ticketTypeLabel.rightAnchor.constraint(equalTo: ticketScanStateImageView.leftAnchor, constant: -12).isActive = true
        ticketTypeLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
