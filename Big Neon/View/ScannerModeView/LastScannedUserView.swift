

import UIKit
import Big_Neon_Core

// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar

public class LastScannedUserView: UIView {
    
    var redeemableTicket: RedeemableTicket? {
        didSet {
            guard let ticket = self.redeemableTicket else {
                return
            }
            
            self.userNameLabel.text = ticket.firstName
            self.ticketTypeLabel.text = ticket.ticketType
            
        }
    }
    
    public var scanFeedback: ScanFeedback? {
        didSet {
            guard let feedback = self.scanFeedback else {
                return
            }
            
            switch feedback {
            case .valid:
                ticketScanStateTagView.backgroundColor = UIColor.brandGreen
                ticketScanStateTagView.tagLabel.text = "VALID"
            case .alreadyRedeemed:
                ticketScanStateTagView.backgroundColor = UIColor.brandBlack
                ticketScanStateTagView.tagLabel.text = "REDEEMED"
            default:
                ticketScanStateTagView.backgroundColor = UIColor.brandError
                ticketScanStateTagView.tagLabel.text = "-"
            }
        }
    }
    
    public lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20.0
        imageView.backgroundColor = UIColor.brandBackground
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBackground
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ticketScanStateTagView: CheckinTagView = {
        let view = CheckinTagView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.layer.cornerRadius = 38.0
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(userImageView)
        self.addSubview(userNameLabel)
        self.addSubview(ticketTypeLabel)
        self.addSubview(ticketScanStateTagView)
        
        userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        ticketScanStateTagView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ticketScanStateTagView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        ticketScanStateTagView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        ticketScanStateTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: ticketScanStateTagView.leftAnchor, constant: -12).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        ticketTypeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2).isActive = true
        ticketTypeLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        ticketTypeLabel.rightAnchor.constraint(equalTo: ticketScanStateTagView.leftAnchor, constant: -12).isActive = true
        ticketTypeLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
