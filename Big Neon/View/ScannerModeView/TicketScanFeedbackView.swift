

import UIKit
import PWSwitch
import Big_Neon_Core
import Big_Neon_UI


// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: internal is default access level - not need for explicit definition
// MARK: use abbreviation / syntax sugar

public class TicketScanFeedbackView: UIView {
    
    var errorDetail: String? {
        didSet {
            guard let errorDetail = self.errorDetail else {
                return
            }
            feedbackDetailLabel.text = errorDetail
        }
    }
    
    public var scanFeedback: ScanFeedback? {
        didSet {
            guard let feedback = self.scanFeedback else {
                return
            }
            
            switch feedback {
            case .valid:
                self.feedbackLabel.text = "Ticket Valid!"
                self.feedbackImageView.image = UIImage(named: "ic_ticketValid")
            case .issueFound:
                self.feedbackLabel.text = "We found an issue"
                self.feedbackImageView.image = UIImage(named: "ic_issueFound")
            case .wrongEvent:
                self.feedbackLabel.text = "Wrong Event"
                self.feedbackImageView.image = UIImage(named: "ic_issueFound")
            case .ticketNotFound:
                self.feedbackLabel.text = "No Ticket Found"
                self.feedbackImageView.image = UIImage(named: "ic_issueFound")
            default:
                self.feedbackLabel.text = "Already Redeemed"
                self.feedbackImageView.image = UIImage(named: "ic_alreadyRedeemed")
            }
        }
    }
    
    let feedbackLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let feedbackDetailLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.textColor = UIColor.white
        label.text = "No Network Connection"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let feedbackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.layer.cornerRadius = 10.0
        self.configureView()
    }
    
    private func configureView() {
        addSubview(feedbackImageView)
        addSubview(feedbackLabel)
        addSubview(feedbackDetailLabel)
        
        feedbackImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16.0).isActive  = true
        feedbackImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        feedbackImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        feedbackImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        feedbackLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive  = true
        feedbackLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        feedbackLabel.topAnchor.constraint(equalTo: feedbackImageView.bottomAnchor, constant: 20.0).isActive = true
        feedbackLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        feedbackDetailLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive  = true
        feedbackDetailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        feedbackDetailLabel.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: 10.0).isActive = true
        feedbackDetailLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
