

import Foundation
import UIKit
import Big_Neon_Core
import Big_Neon_UI
import PanModal

protocol GuestListViewDelegate: class {
    func reloadGuests()
}

final class GuestListViewController: UIViewController, PanModalPresentable, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, GuestListViewDelegate, UITableViewDataSourcePrefetching {

    weak var delegate: ScannerViewDelegate?
    var guestsDictionary: [String: [RedeemableTicket]] = [:]
    var guestSectionTitles = [String]()
    var filteredLocalSearchResults: [RedeemableTicket] = []
    var isSearching: Bool = false
    var isShortFormEnabled = true
    var scanVC: ScannerViewController?
    var isFetchingNextPage = false
    var scannerViewModel = TicketScannerViewModel()
    var guestViewModel = GuestsListViewModel()
    
    var totalGuests: Int? {
        didSet {
            guard let totalGuests = self.totalGuests else {
                return
            }
            headerView.totalGuests = totalGuests
        }
    }
    
    public var  guests: [RedeemableTicket]? {
        didSet {
            guard let guests = self.guests else {
                return
            }
            
            configureNavBar()
            configureView()
            guestsDictionary.removeAll()
            
            for guest in guests {
                let guestKey = String(guest.firstName.prefix(1).uppercased())
                if var guestValues = guestsDictionary[guestKey] {
                    guestValues.append(guest)
                    guestsDictionary[guestKey] = guestValues
                } else {
                    guestsDictionary[guestKey] = [guest]
                }
            }
            
            self.guestSectionTitles = [String](guestsDictionary.keys)
            self.guestSectionTitles = guestSectionTitles.sorted(by: { $0 < $1 })
        }
    }

    lazy var headerView: GuestListHeaderView = {
        let view = GuestListHeaderView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var guestTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.separatorColor = UIColor.brandGrey.withAlphaComponent(0.3)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Search for guests"
        search.searchBar.scopeButtonTitles = nil
        search.searchBar.scopeBarBackgroundImage = nil
        search.searchBar.backgroundImage = UIImage()
        search.searchBar.setBackgroundImage(UIImage(named: "search_box"), for: UIBarPosition.bottom, barMetrics: UIBarMetrics.default)
        search.searchBar.barStyle = .default
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        return search
    }()
    
    init(eventID: String, eventTimeZone: String) {
        guestViewModel.eventID = eventID
        guestViewModel.eventTimeZone = eventTimeZone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //perform(#selector(fetchUpdatedGuests), with: self, afterDelay: 1.0)
    }

    func fetchGuests() {
        guard let eventID = guestViewModel.eventID else {
            return
        }

        self.scannerViewModel.fetchGuests(forEventID: eventID, page: 0, completion: { [weak self] (completed) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.guests = self.scannerViewModel.ticketsFetched
            }
        })
    }

    @objc func fetchUpdatedGuests() {

        guard let eventID = guestViewModel.eventID, let timeZone = guestViewModel.eventTimeZone else {
            return
        }

        self.guestViewModel.fetchNewTicketUpdates(forEventID: eventID, eventTimeZone: timeZone, completion: { [weak self] (completed) in
            DispatchQueue.main.async {
               return
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.scanVC?.stopScanning = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavBar()
        self.navigationItem.titleView = self.searchController.searchBar
    }
    
    func configureNavBar() {
        navigationNoLineBar()
        navigationController?.navigationBar.barTintColor = UIColor.brandBackground
        navigationController?.navigationBar.tintColor = UIColor.brandBlack
    }
    
    private func configureSearch() {
        navigationItem.searchController = searchController
    }
    
    private func configureView() {
        
        view.addSubview(headerView)
        view.addSubview(guestTableView)
        guestTableView.register(GuestTableViewCell.self, forCellReuseIdentifier: GuestTableViewCell.cellID)
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        
        guestTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        guestTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        guestTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        guestTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    var panScrollable: UIScrollView? {
        return guestTableView
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(600)
    }
    
    func reloadGuests() {
        guard let eventID = self.guestViewModel.eventID else {
            return
        }
        
        self.scannerViewModel.fetchGuests(forEventID: eventID, page: guestViewModel.currentPage, completion: { [weak self] (completed) in
            DispatchQueue.main.async {
                self?.guests = (self?.scannerViewModel.ticketsFetched)!
                self?.guestTableView.reloadData()
                self?.headerView.isRefreshing = false
                return
            }
        })
    }
    
    func reloadGuests(atIndex index: IndexPath) {
        let redeemedCell: GuestTableViewCell = guestTableView.cellForRow(at: index) as! GuestTableViewCell
        redeemedCell.ticketStateView.tagLabel.text = "REDEEMED"
        redeemedCell.ticketStateView.backgroundColor = UIColor.brandBlack
    }
}
