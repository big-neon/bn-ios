



import Foundation
import UIKit
import Big_Neon_Core
import Big_Neon_UI


final class EventViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSourcePrefetching {

    var guestsDictionary: [String: [RedeemableTicket]] = [:]
    var filteredLocalSearchResults: [RedeemableTicket] = []
    var isFetchingNextPage = false
    var scanButtonBottomAnchor: NSLayoutConstraint?
    var isSearching: Bool = false
//    public var  guests: [RedeemableTicket]?
    
    lazy var guestTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
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
    
    lazy var scanTicketsButton: ScanTicketsButton = {
        let button = ScanTicketsButton()
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showScanner)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        configureNavBar()
        configureTableView()
        configureHeaderView()
        configureScanButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        refresher.addTarget(self, action: #selector(reloadGuests), for: .valueChanged)
        guestTableView.refreshControl = self.refresher
        fetchGuests()
        
    }
    
    func fetchGuests() {
        self.eventViewModel.fetchGuests(page: 0) { (fetched) in
            DispatchQueue.main.async {
                self.eventViewModel.guestCoreData = self.eventViewModel.fetchLocalGuests()
                self.perform(#selector(self.isTodayEvent), with: self, afterDelay: 0.1)
                self.guestTableView.reloadData()
            }
        }
    }
    
    @objc func reloadGuests() {
        /*
        self.eventViewModel.fetchEventGuests(page: eventViewModel.currentPage, completion: { [weak self] (completed) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.guestTableView.reloadData()
                self.refresher.endRefreshing()
                self.isTodayEvent()
                return
            }
        })
         */
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

    private func configureScanButton() {
        view.addSubview(scanTicketsButton)
    
        scanButtonBottomAnchor = scanTicketsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 200.0)
        scanButtonBottomAnchor?.isActive = true
        scanTicketsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        scanTicketsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        scanTicketsButton.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
    }
    
    @objc func isTodayEvent() {
        guard let event = self.eventViewModel.eventData, let eventDate = event.event_start else {
            return
        }
        
        if self.eventViewModel.guestCoreData.isEmpty {
            return
        }
        
        let isEventDate = DateConfig.eventDateIsToday(eventStartDate: eventDate)
        self.showScanButton(isEventDate: isEventDate)
    }
    
    func showScanButton(isEventDate: Bool) {
        UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            self.scanButtonBottomAnchor?.constant = isEventDate == true ? -LayoutSpec.Spacing.twenty : +200.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showGuest(withTicket guest: GuestData?, selectedIndex: IndexPath) {
        let guestVC = GuestViewController()
        guestVC.event = self.eventViewModel.eventData
        guestVC.guest = guest
        guestVC.guestListIndex = selectedIndex
        self.presentPanModal(guestVC)
    }
    
    @objc func showScanner() {
        viewAnimationBounce(viewSelected: scanTicketsButton, bounceVelocity: 10.0, springBouncinessEffect: 15.0)
        let scannerVC = ScannerViewController()
        scannerVC.modalPresentationStyle = .fullScreen
        scannerVC.event = self.eventViewModel.eventData
        let scannerNavVC = UINavigationController(rootViewController: scannerVC)
        scannerNavVC.modalPresentationStyle = .fullScreen
        self.present(scannerNavVC, animated: true, completion: nil)
    }
    
    
}
