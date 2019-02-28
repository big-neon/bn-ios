

import Foundation
import UIKit
import Big_Neon_Core

public class GuestListView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    public var guests: [User]? {
        didSet {
            guard let guests = self.guests else {
                return
            }
            
            self.guestTableView.reloadData()
            
        }
    }
    
    internal var isShowingGuests: Bool? {
        didSet {
            guard let isShowingGuest = self.isShowingGuests else {
                return
            }
            
            if isShowingGuest == true {
                return
            }
            
        }
    }
    
    public lazy var showGuestButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(showGuest), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(named: "ic_upArrow"), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public let allguestsLabel: UILabel = {
        let label = UILabel()
        label.text = "All Guests"
        label.textColor = UIColor.brandBlack
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal lazy var guestTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.brandGrey.withAlphaComponent(0.3)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 12.0
        self.layer.shadowColor = UIColor.brandBlack.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        self.layer.shadowRadius = 16.0
        self.layer.shadowOpacity = 0.32
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(allguestsLabel)
        self.addSubview(showGuestButton)
        self.addSubview(guestTableView)
        
        self.guestTableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
        
        allguestsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28).isActive = true
        allguestsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        allguestsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        allguestsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        showGuestButton.centerYAnchor.constraint(equalTo: allguestsLabel.centerYAnchor).isActive = true
        showGuestButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        showGuestButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        showGuestButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        guestTableView.topAnchor.constraint(equalTo: guestTableView.bottomAnchor, constant: 32).isActive = true
        guestTableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        guestTableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        guestTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    @objc private func showGuest() {
        self.isShowingGuests = !self.isShowingGuests!
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
