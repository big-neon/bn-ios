
import UIKit
import Big_Neon_UI
import Big_Neon_Core

class GuestListHeaderView: UIView {
    
    struct Constants {
        static let contentInsets = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
    }
    
    var event: EventsData? {
        didSet {
            guard let event = self.event else  {
                return
            }
            titleLabel.text = event.name
        }
    }
    
    var guests: [RedeemableTicket]? {
        didSet {
            
            guard let guests = self.guests else  {
                return
            }
            
            if guests.count == 1 {
                subtitleLabel.text = "\(guests.count) guest"
            } else {
                subtitleLabel.text = "\(guests.count) guests"
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
        label.textColor = UIColor.brandBlack
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.medium)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.brandBackground
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentInsets.top).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentInsets.right).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.contentInsets.bottom).isActive = true
    }
    
    
}
