

import Foundation
import UIKit
import PresenterKit
import Big_Neon_UI

final class TicketTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    internal var modalActive: Bool = false
    internal var eventDetailsVC: EventDetailViewController?
    internal let ticketTypeViewModel: TicketTypeViewModel = TicketTypeViewModel()
    
    internal let headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Ticket Type"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.black)
        label.textColor = UIColor.brandBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
        button.tintColor = UIColor.brandBlack
        button.imageEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        button.backgroundColor = UIColor.brandBackground.withAlphaComponent(0.5)
        button.layer.cornerRadius = 16.0
        button.addTarget(self, action: #selector(handleClose), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal lazy var eventTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.white
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false 
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsSelection = true
        tableView.separatorColor = UIColor.brandGrey.withAlphaComponent(0.3)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
        self.view.addSubview(closeButton)
        self.view.addSubview(eventTableView)
        
        eventTableView.register(TicketTypeCell.self, forCellReuseIdentifier: TicketTypeCell.cellID)
        
        self.headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive  = true
        self.headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive  = true
        self.headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.closeButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
        self.closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        self.eventTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.eventTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.eventTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        self.eventTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc private func handleClose() {
        buttonBounceAnimation(buttonPressed: closeButton)
        self.dismiss(animated: true, completion: nil)
    }
}
