

import UIKit
import PWSwitch

public enum ScanFeedback {
    case valid
    case alreadyRedeemed
    case issueFound
}

public class TicketScanFeedbackView: UIView {
    
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
            default:
                self.feedbackLabel.text = "Already Redeemed"
                self.feedbackImageView.image = UIImage(named: "ic_alreadyRedeemed")
            }
        }
    }
    
    internal let feedbackLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal let feedbackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(feedbackImageView)
        self.addSubview(feedbackLabel)
        
        feedbackImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive  = true
        feedbackImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        feedbackImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        feedbackImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        feedbackLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive  = true
        feedbackLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        feedbackLabel.topAnchor.constraint(equalTo: feedbackImageView.bottomAnchor, constant: 16.0).isActive = true
        feedbackLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
