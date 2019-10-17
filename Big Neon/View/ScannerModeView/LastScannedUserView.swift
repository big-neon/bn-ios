

import UIKit
import Big_Neon_Core
import Big_Neon_UI

public class LastScannedUserView: BrandShadowView {
    
    var delegate: ScannerViewDelegate?
    
    var redeemableTicket: RedeemableTicket? {
        didSet {
            guard let ticket = self.redeemableTicket else {
                return
            }
            
            self.userNameLabel.text = ticket.firstName
            self.ticketTypeLabel.text = ticket.ticketType
            
        }
    }
    
    var guestData: GuestData? {
        didSet {
            guard let ticket = self.guestData else {
                return
            }
            
            self.userNameLabel.text = ticket.first_name!
            self.ticketTypeLabel.text = ticket.ticket_type!
            
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
                ticketScanStateTagView.tagLabel.text = "WRONG SHOW"
            case .notEventDate:
                ticketScanStateTagView.backgroundColor = UIColor.brandGrey
                ticketScanStateTagView.tagLabel.text = "TOO EARLY"
            default:
                ticketScanStateTagView.backgroundColor = UIColor.brandError
                ticketScanStateTagView.tagLabel.text = "ERROR"
            }
        }
    }
    
    public var isFetchingData: Bool = false {
        didSet {
            self.userImageView.isHidden = isFetchingData
            self.userNameLabel.isHidden = isFetchingData
            self.ticketTypeLabel.isHidden = isFetchingData
            self.ticketScanStateTagView.isHidden = isFetchingData
            
            if isFetchingData == true {
                self.loadingView.startAnimating()
            } else {
                self.loadingView.stopAnimating()
            }
            
        }
    }
    
    let loadingView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = UIActivityIndicatorView.Style.gray
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    public lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showScannedTicket)))
        imageView.image = UIImage(named: "empty_profile")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showScannedTicket)))
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showScannedTicket)))
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ticketScanStateTagView: CheckinTagView = {
        let view = CheckinTagView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showScannedTicket)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white    //  .withAlphaComponent(0.8)
        self.layer.cornerRadius = 38.0
        self.configureView()
        self.loadingAnimation()
    }
    
    private func loadingAnimation() {
        addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    override public func configureView() {
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
        ticketScanStateTagView.widthAnchor.constraint(equalToConstant: 90).isActive = true

        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: ticketScanStateTagView.leftAnchor, constant: -LayoutSpec.Spacing.twelve).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true

        ticketTypeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2).isActive = true
        ticketTypeLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        ticketTypeLabel.rightAnchor.constraint(equalTo: ticketScanStateTagView.leftAnchor, constant: -LayoutSpec.Spacing.twelve).isActive = true
        ticketTypeLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.sixteen).isActive = true
        
    }
    
    @objc func showScannedTicket() {
        self.delegate?.showRedeemedTicket()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
