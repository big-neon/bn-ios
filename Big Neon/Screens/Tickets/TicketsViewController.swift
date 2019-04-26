
import UIKit
import Big_Neon_UI

// MARK:  magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar
// MARK: internal is default access level - not need for explicit definition

final class TicketsViewController: BaseViewController {
    
    internal lazy var noTicketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_emptyTicket")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // lazy?
    internal let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_headerLogo")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    internal var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
        label.text = "Looks like you don’t have any upcoming events! Why not tap browse and have a look? "
        label.textAlignment = .center
        label.textColor =  UIColor.brandLightGrey
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.brandBackground
        self.configureNavBar()
        self.configureEmptyView()
    }
    
    private func configureNavBar() {
        self.headerImageView.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        self.navigationItem.titleView = self.headerImageView
        self.navigationNoLineBar()
    }
    
    private func configureEmptyView() {
        self.view.addSubview(noTicketImageView)
        self.view.addSubview(detailLabel)
        
        self.noTicketImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.noTicketImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -70).isActive = true
        self.noTicketImageView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        self.noTicketImageView.heightAnchor.constraint(equalToConstant: 110.0).isActive = true
        
        self.detailLabel.topAnchor.constraint(equalTo: noTicketImageView.bottomAnchor, constant: 45).isActive = true
        self.detailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        self.detailLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
        self.detailLabel.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
    }
}
