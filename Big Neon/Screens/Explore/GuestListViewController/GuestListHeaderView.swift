
import UIKit
import Big_Neon_UI
import Big_Neon_Core

class GuestListHeaderView: UIView {
    
    struct Constants {
        static let contentInsets = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
    }
    
    weak var delegate: GuestListViewDelegate?
    
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
        label.textColor = UIColor.brandPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.brandPrimary
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_refresh"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleReloadGuest), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        addSubview(subtitleLabel)
        addSubview(refreshButton)
        
        subtitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        subtitleLabel.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        refreshButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        refreshButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentInsets.left).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        refreshButton.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
    }
    
    @objc func handleReloadGuest() {
        self.delegate?.reloadGuests()
    }
    
    
}
