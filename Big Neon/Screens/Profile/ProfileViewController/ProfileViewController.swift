

import UIKit
import Big_Neon_UI

protocol ProfileViewDelegate: class {
    func handleUploadImage()
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileViewDelegate  {
    
    var profileHeaderView: ProfileHeaderView = ProfileHeaderView()
    var profileViewModel: ProfileViewModel = ProfileViewModel()
    let picker = UIImagePickerController()
    var qrCodeViewTopConstraint: NSLayoutConstraint?
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(reloadProfile), for: UIControl.Event.valueChanged)
        refresher.tintColor = UIColor.brandGrey
        refresher.addTarget(self, action: #selector(fetchUser), for: .valueChanged)
        return refresher
    }()
    
    let loadingIndicatorView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = UIActivityIndicatorView.Style.gray
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private func configureLoadingView() {
        self.view.addSubview(loadingIndicatorView)
        loadingIndicatorView.startAnimating()
        loadingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingIndicatorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loadingIndicatorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }

    lazy var profileTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = UIColor.brandBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.separatorColor = UIColor.brandGrey.withAlphaComponent(0.3)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureLoadingView()
        fetchUser()
        configureObservers()
        navigationClearBar()
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationClearBar()
    }

    @objc private func fetchUser() {
        self.profileViewModel.configureAccessToken(completion: ) { [weak self] (completed) in
            DispatchQueue.main.async {
                self?.loadingIndicatorView.stopAnimating()
                self?.configureTableView()
                self?.configureHeaderView()
            }
        }
    }


    private func configureObservers() {
        let reloadKey = Notification.Name(Constants.AppActionKeys.profileUpdateKey)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadProfile), name: reloadKey, object: nil)
    }

    @objc func reloadProfile() {
        self.profileViewModel.configureAccessToken(completion: ) { [weak self] (completed) in
            DispatchQueue.main.async {
                print(completed)
                self?.refresher.endRefreshing()
                self?.profileTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sizeHeaderToFit()
    }
    
    private func sizeHeaderToFit() {
        profileHeaderView.setNeedsLayout()
        profileHeaderView.layoutIfNeeded()
        var frame = profileHeaderView.frame
        frame.size.height = CGFloat(280.0)
        profileHeaderView.frame = frame
    }
    
    private func configureHeaderView() {
        profileHeaderView  = ProfileHeaderView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 280.0))
        profileHeaderView.delegate = self
        guard let user = self.profileViewModel.user else {
            profileTableView.tableHeaderView = profileHeaderView
            return
        }
        profileHeaderView.user = user
        profileTableView.tableHeaderView = profileHeaderView
    }
    
    private func configureTableView() {
        self.view.addSubview(profileTableView)
        
        profileTableView.register(ProfileTableCell.self, forCellReuseIdentifier: ProfileTableCell.cellID)
        
        profileTableView.refreshControl = refresher
        profileTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    internal func editProfileViewController() {
        let profileEditVC = ProfileEditViewController()
        profileEditVC.profleEditViewModel.user = self.profileViewModel.user
        let profileEditNavVC = UINavigationController(rootViewController: profileEditVC)
        self.present(profileEditNavVC, animated: true, completion: nil)
    }
}

