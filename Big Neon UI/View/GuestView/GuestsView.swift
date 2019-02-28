

import Foundation
import UIKit
import Big_Neon_Core

public protocol GuestListViewProtocol {
    func showGuestList()
}

public class GuestListView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    public var delegate: GuestListViewProtocol?
    
    public var guests: [User]? {
        didSet {
            guard let guests = self.guests else {
                return
            }
            
            self.guestTableView.reloadData()
            
        }
    }
    
    internal var isShowingGuests: Bool = false {
        didSet {
            if isShowingGuests == true {
                UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.85, options: .curveEaseOut, animations: {
                    self.showGuestButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    self.layoutIfNeeded()
                }, completion: nil)
                return
            }
            
            UIView.animate(withDuration: 0.9, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.85, options: .curveEaseOut, animations: {
                self.showGuestButton.transform = CGAffineTransform.identity
                self.layoutIfNeeded()
            }, completion: nil)
            return
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
        
        self.guestTableView.register(GuestTableViewCell.self, forCellReuseIdentifier: GuestTableViewCell.cellID)
        
        allguestsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28).isActive = true
        allguestsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        allguestsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        allguestsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        showGuestButton.centerYAnchor.constraint(equalTo: allguestsLabel.centerYAnchor).isActive = true
        showGuestButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        showGuestButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        showGuestButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        guestTableView.topAnchor.constraint(equalTo: allguestsLabel.bottomAnchor, constant: 24).isActive = true
        guestTableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        guestTableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        guestTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    @objc private func showGuest() {
        self.isShowingGuests = !self.isShowingGuests
        self.delegate?.showGuestList()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
