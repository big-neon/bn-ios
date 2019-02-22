
import UIKit
import Big_Neon_UI
import Big_Neon_Core

final class DoorPersonViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    internal lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.brandGrey
        refresher.addTarget(self, action: #selector(reloadEvents), for: .valueChanged)
        return refresher
    }()

    internal lazy var exploreCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 18.0
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets(top: 38.0, left: 0.0, bottom: 15.0, right: 0.0)
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
        search.searchResultsUpdater = self
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
        imageView.backgroundColor = UIColor.brandGrey
        imageView.layer.cornerRadius = 15.0
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.brandGrey.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.configureSearch()
        self.fetchCheckins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.configureNavBar()
    }

    private func fetchCheckins() {
        self.loadingView.startAnimating()
        self.doorPersonViemodel.configureAccessToken { (completed) in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                if completed == false {
                    print(completed)
                    return
                }
                self.configureCollectionView()
            }
        }
    }
    
    @objc private func reloadEvents() {
        self.doorPersonViemodel.configureAccessToken { (completed) in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.refresher.endRefreshing()
                
                if completed == false {
                    self.exploreCollectionView.reloadData()
                    print("Failed to Reload View")
                    return
                }
                self.exploreCollectionView.reloadData()
                return
            }
        }
    }
    
    private func configureSearch() {
//        self.navigationItem.searchController = searchController
    }

    private func configureNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.brandBlack,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)]
        self.navigationItem.title = "Doorperson"
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        //  Profile Picture
        userProfileImageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userProfileImageView)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.done, target: self, action: #selector(handleLogout))
    }

    private func configureCollectionView() {
        view.addSubview(exploreCollectionView)
        exploreCollectionView.refreshControl = self.refresher
        exploreCollectionView.register(SectionHeaderCell.self, forCellWithReuseIdentifier: SectionHeaderCell.cellID)
        exploreCollectionView.register(HotThisWeekCell.self, forCellWithReuseIdentifier: HotThisWeekCell.cellID)
        exploreCollectionView.register(UpcomingEventCell.self, forCellWithReuseIdentifier: UpcomingEventCell.cellID)
        
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
    
    internal func showScanner() {
        let scannerNavVC = UINavigationController(rootViewController: TicketScannerViewController())
        self.present(scannerNavVC, animated: true, completion: nil)
    }

}

