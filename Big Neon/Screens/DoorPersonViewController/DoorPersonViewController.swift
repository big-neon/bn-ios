
import UIKit
import Sync
import Big_Neon_UI
import Big_Neon_Core

protocol DoorPersonViewDelegate: class {
    func handleShowProfile()
}

final class DoorPersonViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, DoorPersonViewDelegate {

    var eventsFetcher: EventsFetcher

    var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "No Published Events"
        label.textColor = UIColor.brandBlack
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Your published and upcoming events will be found here."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textColor = UIColor.brandGrey
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var exploreCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20.0
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 24.0, right: 0.0)
        collectionView.backgroundColor = UIColor.brandBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search artists, shows, venues…"
        search.searchBar.scopeButtonTitles = nil
        search.searchBar.scopeBarBackgroundImage = nil
        search.searchBar.backgroundImage = nil
        search.searchBar.backgroundImage(for: UIBarPosition.bottom, barMetrics: UIBarMetrics.default)
        search.searchBar.barStyle = .default
        definesPresentationContext = true
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        return search
    }()
    
    init(fetcher: EventsFetcher) {
        self.eventsFetcher = fetcher
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresher.addTarget(self, action: #selector(reloadEvents), for: .valueChanged)
        configureNavBar()
        view.backgroundColor = UIColor.white
        configureCollectionView()
        fetchEvents()
    }
    
    func fetchEvents() {
        NetworkManager.shared.startNetworkReachabilityObserver { (isReachable) in
            if isReachable == true {
                self.doorPersonViemodel.fetchUser { (_) in
                    DispatchQueue.main.async {
                        guard let orgID = self.doorPersonViemodel.userOrg?.organizationScopes?.first?.key else {
                            return
                        }
                        self.syncEventsData(withOrgID: orgID)
                        self.exploreCollectionView.reloadData()
                    }
                }
            } else {
                self.doorPersonViemodel.eventCoreData = self.fetcher.fetchLocalEvents()
                self.syncEventsData(withOrgID: nil)
                self.exploreCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureNavBar()
        listenForNetworkFeedback()
    }
    
    func listenForNetworkFeedback() {
        NetworkManager.shared.startNetworkReachabilityObserver { (isReachable) in
            if isReachable == false {
                if let window = UIApplication.shared.keyWindow {
                    self.networkFeedback.showFeedback(currentView: window)
                }
            }
        }
    }

    private func configureNavBar() {
        self.hideNavBar()
    }

    private func configureEmptyView() {
        exploreCollectionView.isHidden = true
        view.addSubview(headerLabel)
        view.addSubview(detailLabel)

        headerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true

        detailLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: LayoutSpec.Spacing.twentyFour).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true

    }

    private func configureCollectionView() {
        view.addSubview(exploreCollectionView)
        exploreCollectionView.refreshControl = self.refresher
        exploreCollectionView.register(SectionHeaderCell.self, forCellWithReuseIdentifier: SectionHeaderCell.cellID)
        exploreCollectionView.register(HotThisWeekCell.self, forCellWithReuseIdentifier: HotThisWeekCell.cellID)
        exploreCollectionView.register(DoorPersonCell.self, forCellWithReuseIdentifier: DoorPersonCell.cellID)
        exploreCollectionView.register(HomeSectionCell.self, forCellWithReuseIdentifier: HomeSectionCell.cellID)
        
        exploreCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        exploreCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        exploreCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        exploreCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    internal func showEvent(event: Event) {
        let eventDetailVC = EventDetailViewController()
        eventDetailVC.eventDetailViewModel.event = event
        eventDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(eventDetailVC, animated: true)
    }
    
    func handleShowProfile() {
        self.navigationController?.push(ProfileViewController())
    }
    
    func showScanner(forTicketIndex ticketIndex: Int, section: Int) {
        /*
        let scannerVC = ScannerViewController(fetcher: guestsFetcher)
        scannerVC.modalPresentationStyle = .fullScreen
        scannerVC.event = section == 1 ? self.doorPersonViemodel.todayEvents[ticketIndex] : self.doorPersonViemodel.upcomingEvents[ticketIndex]
        let scannerNavVC = UINavigationController(rootViewController: scannerVC)
        scannerNavVC.modalPresentationStyle = .fullScreen
        self.present(scannerNavVC, animated: true, completion: nil)
        */
    }
    
    func showEvent(forTicketIndex ticketIndex: Int, section: Int) {
        let event = section == 1 ? self.doorPersonViemodel.todayEvents[ticketIndex] : self.doorPersonViemodel.upcomingEvents[ticketIndex]
        let eventVC = EventViewController(event: event, presentedFromScannerVC: false)
        self.navigationController?.push(eventVC)
    }

}

