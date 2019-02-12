

import Foundation
import UIKit
import PresenterKit
import Big_Neon_UI

final class TicketTypeViewController: UIViewController {
    
    internal var modalActive: Bool = false
    internal var eventDetailsVC: EventDetailViewController?
    
    internal let headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Ticket Type"
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.black)
        label.textColor = UIColor.brandBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.configureView()
    }
    
    override func viewWillLayoutSubviews() {
        self.view.roundCorners([.topLeft, .topRight], radius: 16.0)
        self.view.layer.masksToBounds = true
        self.view.layoutIfNeeded()
    }
    
    deinit {
        if eventDetailsVC != nil {
            eventDetailsVC?.modalActive = false
        }
    }
    
    private func configureView() {
        self.view.addSubview(headerLabel)
        
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive  = true
        headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive  = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
