

import Foundation
import UIKit
import PresenterKit
import Big_Neon_UI

final class TicketTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    internal var modalActive: Bool = false
    internal var isInCheckout: Bool = false
    internal var eventDetailsVC: EventDetailViewController?
    internal let ticketTypeViewModel: TicketTypeViewModel = TicketTypeViewModel()
    
    //  Animation Anchors
    internal var backButtonLeftAnchor: NSLayoutConstraint?
    internal var closeButtonRightAnchor: NSLayoutConstraint?
    internal var purchaseTicketBottomAnchor: NSLayoutConstraint?
    
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
    
    internal lazy var backButtonButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_back-white")?.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
        button.tintColor = UIColor.brandBlack
        button.imageEdgeInsets = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
        button.backgroundColor = UIColor.brandBackground.withAlphaComponent(0.5)
        button.layer.cornerRadius = 18.0
        button.addTarget(self, action: #selector(moveToTicketType), for: UIControl.Event.touchUpInside)
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
    
    internal lazy var checkoutTableView: UITableView = {
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
    
    internal lazy var purchaseTicketButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        button.backgroundColor = UIColor.brandPrimary
//        button.addTarget(self, action: #selector(handleSelectTypeType), for: UIControl.Event.touchUpInside)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.setTitle("Purchase Ticket", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        self.view.addSubview(backButtonButton)
        self.view.addSubview(headerLabel)
        self.view.addSubview(closeButton)
        self.view.addSubview(eventTableView)
        self.view.addSubview(purchaseTicketButton)
        
        eventTableView.register(TicketTypeCell.self, forCellReuseIdentifier: TicketTypeCell.cellID)
        
        self.backButtonLeftAnchor = self.backButtonButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -36)
        self.backButtonLeftAnchor?.isActive = true
        self.backButtonButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
        self.backButtonButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        self.backButtonButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        self.headerLabel.leftAnchor.constraint(equalTo: backButtonButton.rightAnchor, constant: 20).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive  = true
        self.headerLabel.centerYAnchor.constraint(equalTo: backButtonButton.centerYAnchor).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.closeButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
        self.closeButtonRightAnchor = self.closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        self.closeButtonRightAnchor?.isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        self.eventTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.eventTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.eventTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 22).isActive = true
        self.eventTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.purchaseTicketButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.purchaseTicketButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.purchaseTicketBottomAnchor = self.purchaseTicketButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80)
        self.purchaseTicketBottomAnchor?.isActive = true
        self.purchaseTicketButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    @objc private func handleClose() {
        buttonBounceAnimation(buttonPressed: closeButton)
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func moveToCheckout() {
        self.isInCheckout = true
        
        labelShake(labelToAnimate: self.headerLabel, bounceVelocity: 5.0, springBouncinessEffect: 3.0)
        self.headerLabel.text = "Checkout"
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.eventTableView.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            self.eventTableView.layer.opacity = 0.0
            self.backButtonLeftAnchor?.constant = 20.0
            self.closeButtonRightAnchor?.constant = 90.0
            self.purchaseTicketBottomAnchor?.constant = 0.0
            self.view.layoutIfNeeded()
        }) { (_) in
            print("Showing the Checkout View")
        }
    }

    @objc internal func moveToTicketType() {
        self.isInCheckout = false
        labelShake(labelToAnimate: self.headerLabel, bounceVelocity: 5.0, springBouncinessEffect: 3.0)
        self.headerLabel.text = "Ticket Type"
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.eventTableView.transform = CGAffineTransform.identity
            self.eventTableView.layer.opacity = 1.0
            self.backButtonLeftAnchor?.constant = -34.0
            self.closeButtonRightAnchor?.constant = -20.0
            self.purchaseTicketBottomAnchor?.constant = 90.0
            self.view.layoutIfNeeded()
        }) { (_) in
            print("Animation Reset")
        }
    }
}
