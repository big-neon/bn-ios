
import UIKit
import Big_Neon_UI
import Big_Neon_Core

final class ExploreViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    internal lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.brandGrey
        refresher.addTarget(self, action: #selector(reloadEvents), for: .valueChanged)
        return refresher
    }()
    
    internal lazy var navBarTitleView: ExploreNavigationView = {
        let refresher = ExploreNavigationView()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.fetchEvents()
    }

    private func fetchEvents() {
        self.loadingView.startAnimating()
        self.exploreViewModel.fetchEvents { (completed) in
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
        self.exploreViewModel.fetchEvents { (completed) in
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

    private func configureNavBar() {
        self.navigationNoLineBar()
        navBarTitleView.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        navBarTitleView.widthAnchor.constraint(equalToConstant: 140.0).isActive = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBarTitleView)
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

}

