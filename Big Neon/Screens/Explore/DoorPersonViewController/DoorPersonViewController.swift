
import UIKit
import CoreData
import Big_Neon_UI
import Big_Neon_Core

final class DoorPersonViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    
    internal var dataProvider: DataProvider!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Film> = {
        let fetchRequest = NSFetchRequest<Film>(entityName:"Film")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "episodeId", ascending:true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: dataProvider.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    internal lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.brandGrey
        refresher.addTarget(self, action: #selector(reloadEvents), for: .valueChanged)
        return refresher
    }()
    
    internal var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "No Published Events"
        label.textColor = UIColor.brandBlack
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Your published and upcoming events will be found here."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textColor = UIColor.brandGrey
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    internal lazy var exploreCollectionView: UICollectionView = {
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
    
    internal lazy var searchController: UISearchController = {
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
    
    internal lazy var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowProfile)))
        imageView.image = UIImage(named: "ic_profilePicture")
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.view.backgroundColor = UIColor.white
        self.configureSearch()
        
        dataProvider.fetchFilms { (error) in
            print(error)
        }
        
//        self.fetchCheckins()
//        self.doorPersonViemodel.fetchOfflineEvents { [weak self] (completed) in
//            print(completed)
//            self?.configureCollectionView()
//        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.exploreCollectionView.reloadData()
    }
    
    

    private func fetchCheckins() {
        self.loadingView.startAnimating()
        if Reachability.isConnectedToNetwork() {
            self.doorPersonViemodel.configureAccessToken { [weak self] (completed) in
                DispatchQueue.main.async {
                    self?.loadingView.stopAnimating()
                    if completed == false {
                        print(completed)
                        return
                    }
                    
                    guard ((self?.doorPersonViemodel.events?.data) != nil) else {
                        self?.configureEmptyView()
                        return
                    }
                    
                    self?.configureCollectionView()
//                    self?.doorPersonViemodel.saveEventsOffline(events: (self?.doorPersonViemodel.events)!)
                }
            }
        } else {
//            self.doorPersonViemodel.fetchOfflineEvents { [weak self] (eventsFetched) in
//                self?.configureCollectionView()
//            }
        }
        
    }

    @objc private func reloadEvents() {
        self.doorPersonViemodel.configureAccessToken { [weak self] (completed) in
            DispatchQueue.main.async {
                self?.loadingView.stopAnimating()
                self?.refresher.endRefreshing()
                
                if completed == false {
                    self?.exploreCollectionView.reloadData()
                    print("Failed to Reload View")
                    return
                }
                self?.exploreCollectionView.reloadData()
                return
            }
        }
    }
    
    private func configureSearch() {
//        self.navigationItem.searchController = searchController   //  TO BE ADDED LATER
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationNoLineBar()
    }

    private func configureNavBar() {
        self.navigationNoLineBar()
        self.navigationItem.title = "My Events"
        userProfileImageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userProfileImageView)
    }
    
    private func configureEmptyView() {
        self.exploreCollectionView.isHidden = true
        self.view.addSubview(headerLabel)
        self.view.addSubview(detailLabel)
        
        self.headerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        self.headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        
        self.detailLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24).isActive = true
        self.detailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        self.detailLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        self.detailLabel.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        
    }

    private func configureCollectionView() {
        view.addSubview(exploreCollectionView)
        exploreCollectionView.refreshControl = self.refresher
        exploreCollectionView.register(SectionHeaderCell.self, forCellWithReuseIdentifier: SectionHeaderCell.cellID)
        exploreCollectionView.register(HotThisWeekCell.self, forCellWithReuseIdentifier: HotThisWeekCell.cellID)
        exploreCollectionView.register(DoorPersonCell.self, forCellWithReuseIdentifier: DoorPersonCell.cellID)
        
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
    
    @objc private func handleLogout() {
        self.doorPersonViemodel.handleLogout { (_) in
            let welcomeVC = UINavigationController(rootViewController: WelcomeViewController())
            welcomeVC.modalTransitionStyle = .flipHorizontal
            self.present(welcomeVC, animated: true, completion: nil)
            return
        }
    }
    
    @objc private func handleShowProfile() {
        self.navigationController?.push(ProfileViewController())
    }
    
    internal func showScanner(forTicketIndex ticketIndex: Int) {
        guard let events = self.doorPersonViemodel.events?.data else {
            return
        }
        let scannerVC = ScannerViewController()
        scannerVC.event = events[ticketIndex]
        let scannerNavVC = UINavigationController(rootViewController: scannerVC)
        self.present(scannerNavVC, animated: true, completion: nil)
    }

}

