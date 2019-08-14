

import UIKit
import Big_Neon_Core
import Big_Neon_UI

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
            case .wrongEvent:
                ticketScanStateTagView.backgroundColor = UIColor.brandError
                ticketScanStateTagView.tagLabel.text = "WRONG EVENT"
            default:
                ticketScanStateTagView.backgroundColor = UIColor.brandError
                ticketScanStateTagView.tagLabel.text = "ERROR"
            }
        }
    }
    
    public lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty_profile")
        imageView.contentMode = .scaleAspectFill
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
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        ticketScanStateTagView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ticketScanStateTagView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        ticketScanStateTagView.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true
        ticketScanStateTagView.widthAnchor.constraint(equalToConstant: 88).isActive = true

        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: ticketScanStateTagView.leftAnchor, constant: -LayoutSpec.Spacing.twelve).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true

        ticketTypeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2).isActive = true
        ticketTypeLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        ticketTypeLabel.rightAnchor.constraint(equalTo: ticketScanStateTagView.leftAnchor, constant: -LayoutSpec.Spacing.twelve).isActive = true
        ticketTypeLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.sixteen).isActive = true
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
