
import UIKit
import Big_Neon_UI
import Big_Neon_Core
import TransitionButton

class GuestListHeaderView: UIView {
    
    struct Constants {
        static let contentInsets = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
    }
    
    weak var delegate: GuestListViewDelegate?
    
    var searchResults: Int? {
        didSet {
            guard let results = self.searchResults else  {
                return
            }
            subtitleLabel.text = results == 1 ? "\(results) result" : "\(results) results"
        }
    }
    
    var totalGuests: Int? {
        didSet {
            guard let totalGuests = self.totalGuests else  {
                return
            }
            
            subtitleLabel.text = totalGuests == 1 ? "\(totalGuests) guest" : "\(totalGuests) guests"
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
        label.textColor = UIColor.brandGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.brandGreen
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var refreshButton: TransitionButton = {
        let button = TransitionButton()
        button.layer.cornerRadius = 4.0
        button.backgroundColor = UIColor.brandPrimary
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.setTitle("Refresh", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
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
        
        subtitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        subtitleLabel.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
    }
    
    @objc func handleReloadGuest() {
        self.delegate?.reloadGuests()
    }
    
}
