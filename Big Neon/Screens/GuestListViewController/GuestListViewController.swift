

import Foundation
import UIKit
import Big_Neon_Core
import Big_Neon_UI
import Sync

protocol GuestListViewDelegate: class {
    func reloadGuests()
}

final class GuestListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, GuestListViewDelegate, UITableViewDataSourcePrefetching, SwipeTableViewCellDelegate {

    weak var delegate: ScannerViewDelegate?
    var guestsDictionary: [String: [RedeemableTicket]] = [:]
    //: Alphabetic List Removal     -   var guestSectionTitles = [String]()
    var filteredLocalSearchResults: [RedeemableTicket] = []
    
    var isShortFormEnabled = true
    var isFetchingNextPage = false
    var defaultOptions = SwipeOptions()
    
    var scanVC: ScannerViewController
    var scannerViewModel: TicketScannerViewModel
    var guestViewModel = GuestsListViewModel()
    
    var guestsFetcher: GuestsFetcher?
    var event: EventsData?
    
    var isSearching: Bool = false {
        didSet {
            if isSearching == false {
                headerView.totalGuests = totalGuests
            }
        }
    }
    
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
            
            /*
             Alphabetic guest list removal
             
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
            */
        }
    }
    
    public var  guestsCoreData: [GuestData]? {
        didSet {
            guard let guests = self.guestsCoreData else {
                return
            }
            
            configureNavBar()
            configureView()
            guestsDictionary.removeAll()
            /*
             Alphabetic List Removal
            self.guestSectionTitles = [String](guestsDictionary.keys)
            self.guestSectionTitles = guestSectionTitles.sorted(by: { $0 < $1 })
            */
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
        tableView.keyboardDismissMode = .interactive
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
    
    init(eventID: String, guestsFetched: [RedeemableTicket], eventTimeZone: String, scannerVC: ScannerViewController, scannerVM: TicketScannerViewModel) {
        
        scannerViewModel = scannerVM

        guestViewModel.eventID = eventID
        guestViewModel.eventTimeZone = eventTimeZone
        scanVC = scannerVC
        guests = guestsFetched
        guestViewModel.totalGuests = scannerVM.totalGuests

        guestViewModel.currentTotalGuests = scannerVM.currentTotalGuests
        guestViewModel.currentPage = scannerVM.currentPage
        guestViewModel.ticketsFetched = guestsFetched
        totalGuests = scannerVM.totalGuests
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }

    func fetchGuests() {
        guard let eventID = guestViewModel.eventID else {
            return
        }

        self.scannerViewModel.fetchEventGuests(forEventID: eventID, page: 0, completion: { [weak self] (completed) in
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
        self.scanVC.stopScanning = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavBar()
    }
    
    @objc func handleDimiss() {
        self.scanVC.isShowingScannedUser = false
        self.scanVC.lastScannedTicketTime = nil
        self.scanVC.scannerViewModel?.lastRedeemedTicket = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureNavBar() {
        navigationNoLineBar()
        navigationController?.navigationBar.barTintColor = UIColor.brandBackground
        navigationController?.navigationBar.tintColor = UIColor.brandPrimary
        if let eventName = self.scanVC.event!.name {
            self.setNavigationTitle(withTitle: eventName)
        }
        self.navigationItem.searchController = searchController
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDimiss))
    }
    
    private func configureSearch() {
        navigationItem.searchController = searchController
    }
    
    private func configureView() {
        
//        view.addSubview(headerView)
        view.addSubview(guestTableView)
        
        self.refresher.addTarget(self, action: #selector(reloadGuests), for: .valueChanged)
        guestTableView.refreshControl = self.refresher
        guestTableView.register(GuestTableViewCell.self, forCellReuseIdentifier: GuestTableViewCell.cellID)
        
//        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        headerView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        
        guestTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        guestTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        guestTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        guestTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func panModalWillDismiss() {
        self.scanVC.isShowingScannedUser = false
        self.scanVC.lastScannedTicketTime = nil
        self.scanVC.scannerViewModel?.lastRedeemedTicket = nil
    }
    
    @objc func reloadGuests() {
        
        guard let eventID = self.guestViewModel.eventID else {
            return
        }
        
        self.scannerViewModel.fetchEventGuests(forEventID: eventID, page: guestViewModel.currentPage, completion: { [weak self] (completed) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.guests = self.scannerViewModel.ticketsFetched
                self.guestTableView.reloadData()
                self.refresher.endRefreshing()
                return
            }
        })
    }
    
    func showGuest(withTicket ticket: RedeemableTicket?, selectedIndex: IndexPath) {
        let guestVC = GuestViewController()
        guestVC.event = self.event
        guestVC.redeemableTicket = ticket
        guestVC.guestListVC = self
        guestVC.guestListIndex = selectedIndex
        self.presentPanModal(guestVC)
    }
}
