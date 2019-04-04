

import Foundation
import UIKit
import Big_Neon_Core

public protocol GuestListViewProtocol {
    func showGuestList()
}

public class GuestListView: UIView, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    public func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    public var delegate: GuestListViewProtocol?
    internal var guestsDictionary = [String: [RedeemableTicket]]()
    internal var guestSectionTitles = [String]()
    
    public var guests: Guests? {
        didSet {
            if self.guests == nil  {
                return
            }
            
            self.configureView()
            
            //  Configuring Alphabetic List
            for guest in guests!.data {
                let guestKey = String(guest.firstName.prefix(1))
                if var guestValues = guestsDictionary[guestKey] {
                    guestValues.append(guest)
                    guestsDictionary[guestKey] = guestValues
                } else {
                    guestsDictionary[guestKey] = [guest]
                }
            }
            
            self.guestSectionTitles = [String](guestsDictionary.keys)
            self.guestSectionTitles = guestSectionTitles.sorted(by: { $0 < $1 })
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
    
    internal lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search for guests"
        search.searchBar.scopeButtonTitles = nil
        search.searchBar.scopeBarBackgroundImage = nil
        search.searchBar.backgroundImage = nil
        search.searchBar.backgroundImage(for: UIBarPosition.bottom, barMetrics: UIBarMetrics.default)
        search.searchBar.barStyle = .default
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        return search
    }()
    
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
    
    internal let loadingView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = UIActivityIndicatorView.Style.gray
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private func loadingAnimation() {
        self.addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 12.0
        self.layer.shadowColor = UIColor.brandBlack.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        self.layer.shadowRadius = 16.0
        self.layer.shadowOpacity = 0.32
        self.loadingAnimation()
        self.guestTableView.tableHeaderView = searchController.searchBar
    }
    
    private func configureView() {
        self.loadingView.stopAnimating()
        self.addSubview(allguestsLabel)
        self.addSubview(showGuestButton)
        self.addSubview(guestTableView)

        self.guestTableView.register(GuestTableViewCell.self, forCellReuseIdentifier: GuestTableViewCell.cellID)

        allguestsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        allguestsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        allguestsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        allguestsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        showGuestButton.centerYAnchor.constraint(equalTo: allguestsLabel.centerYAnchor).isActive = true
        showGuestButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32).isActive = true
        showGuestButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        showGuestButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        guestTableView.topAnchor.constraint(equalTo: allguestsLabel.bottomAnchor, constant: 20).isActive = true
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
