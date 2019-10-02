



import Foundation
import UIKit
import Big_Neon_Core
import Big_Neon_UI


final class EventViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSourcePrefetching {

    var guestsDictionary: [String: [RedeemableTicket]] = [:]
    var filteredLocalSearchResults: [RedeemableTicket] = []
    var isFetchingNextPage = false
    var guestsFetcher: GuestsFetcher?
    
    var isSearching: Bool = false
    public var  guests: [RedeemableTicket]?
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
    
    init(event: EventsData) {
        super.init(nibName: nil, bundle: nil)
        self.eventViewModel.eventData = event
        self.setNavigationTitle(withTitle: event.name ?? "")
        self.fetchGuests()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchGuests() {
        self.eventViewModel.fetchEventGuests(page: 0) { (fetched) in
            DispatchQueue.main.async {
                self.configureTableView()
                self.configureHeaderView()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        configureNavBar()
    }
    
    func configureNavBar() {
        navigationNoLineBar()
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.brandPrimary
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: UIBarButtonItem.Style.done, target: self, action: #selector(handleBack))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sizeHeaderToFit()
    }

    private func sizeHeaderToFit() {
        eventTableHeaderView.setNeedsLayout()
        eventTableHeaderView.layoutIfNeeded()
        var frame = eventTableHeaderView.frame
        frame.size.height = CGFloat(300.0)
        eventTableHeaderView.frame = frame
    }

    private func configureHeaderView() {
        eventTableHeaderView  = EventView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300.0))
        eventTableHeaderView.eventData = self.eventViewModel.eventData
        guestTableView.tableHeaderView = eventTableHeaderView
    }
    
    private func configureTableView() {
        
        view.addSubview(guestTableView)
        guestTableView.register(EventGuestsCell.self, forCellReuseIdentifier: EventGuestsCell.cellID)
        
        guestTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        guestTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        guestTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        guestTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func showGuest(withTicket ticket: RedeemableTicket?, selectedIndex: IndexPath) {
        let guestVC = GuestViewController()
        guestVC.event = self.eventViewModel.eventData
        guestVC.redeemableTicket = ticket
//        guestVC.guestListVC = self
        guestVC.guestListIndex = selectedIndex
        self.presentPanModal(guestVC)
    }
    
    
}
