

import Foundation
import UIKit
import Big_Neon_Core
import Big_Neon_UI
import PanModal

final class GuestListViewController: UIViewController, PanModalPresentable, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    weak var delegate: ScannerViewDelegate?
    var guestsDictionary: [String: [RedeemableTicket]] = [:]
    var guestSectionTitles = [String]()
    var filteredSearchResults: [RedeemableTicket] = []
    var isSearching: Bool = false
    
    var isShortFormEnabled = true
    
    public var event: EventsData? {
        didSet {
            guard let event = self.event else  {
                return
            }
            self.setNavigationTitle(withTitle: event.name!)
        }
    }
    
    public var  guests: [RedeemableTicket]? {
        didSet {
            guard let guests = self.guests else  {
                return
            }
            
            configureView()
            guestsDictionary.removeAll()
            for guest in guests {
                let guestKey = String(guest.firstName.prefix(1))
                if var guestValues = guestsDictionary[guestKey] {
                    guestValues.append(guest)
                    guestsDictionary[guestKey] = guestValues
                } else {
                    guestsDictionary[guestKey] = [guest]
                }
            }

            headerView.guests = guests
            self.guestSectionTitles = [String](guestsDictionary.keys)
            self.guestSectionTitles = guestSectionTitles.sorted(by: { $0 < $1 })
        }
    }
    
    lazy var headerView: GuestListHeaderView = {
        let view = GuestListHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var guestTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.brandGrey.withAlphaComponent(0.3)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search for guests"
        search.searchBar.scopeButtonTitles = nil
        search.searchBar.scopeBarBackgroundImage = nil
        search.searchBar.backgroundImage = UIImage()
        search.searchBar.setBackgroundImage(UIImage(named: "search_box"), for: UIBarPosition.bottom, barMetrics: UIBarMetrics.default)
        search.searchBar.barStyle = .default
        definesPresentationContext = true
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureView()
        configureNavBar()
        configureSearch()
    }
    
    func configureNavBar() {
        navigationNoLineBar()
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.brandBlack
    }
    
    private func configureSearch() {
        self.navigationItem.searchController = searchController
    }
    
    private func configureView() {
        
        view.addSubview(headerView)
        view.addSubview(guestTableView)
        guestTableView.register(GuestTableViewCell.self, forCellReuseIdentifier: GuestTableViewCell.cellID)
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        guestTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        guestTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        guestTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        guestTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func reloadGuests() {
        self.guests?.removeAll()
        self.guestTableView.reloadData()
        self.delegate?.reloadGuests()
    }
    
    //  Pan Modal Functions
    var panScrollable: UIScrollView? {
        return guestTableView
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(200)
//        return isShortFormEnabled ? .contentHeight(300.0) : longFormHeight
    }
    
//    var scrollIndicatorInsets: UIEdgeInsets {
//        let bottomOffset = presentingViewController?.bottomLayoutGuide.length ?? 0
//        return UIEdgeInsets(top: headerView.frame.size.height, left: 0, bottom: bottomOffset, right: 0)
//    }
//
//    var anchorModalToLongForm: Bool {
//        return false
//    }
//
//    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
//        let location = panModalGestureRecognizer.location(in: view)
//        return headerView.frame.contains(location)
//    }
//
//    func willTransition(to state: PanModalPresentationController.PresentationState) {
//        guard isShortFormEnabled, case .longForm = state
//            else { return }
//
//        isShortFormEnabled = false
//        panModalSetNeedsLayoutUpdate()
//    }

}
