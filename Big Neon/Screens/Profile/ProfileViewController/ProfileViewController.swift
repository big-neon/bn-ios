

import UIKit
import Big_Neon_UI

internal class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TicketQRCodeDelegate, ProfileHeaderDelegate  {
    
    internal var profileHeaderView: ProfileHeaderView = ProfileHeaderView()
    internal var profileViewModel: ProfileViewModel = ProfileViewModel()
    internal let picker = UIImagePickerController()
    internal var qrCodeViewTopConstraint: NSLayoutConstraint?
    
    internal lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(reloadProfile), for: UIControl.Event.valueChanged)
        refresher.tintColor = UIColor.brandGrey
        refresher.addTarget(self, action: #selector(fetchUser), for: .valueChanged)
        return refresher
    }()
    
    internal lazy var profileQRCodeView: TicketQRCodeView = {
        let view = TicketQRCodeView()
        view.qrCodeImage.image = UIImage(named: "ic_qrcode_large")
        view.delegate = self
        return view
    }()
    
    internal let profileQRCodeBackgroundView: UIView = {
        let view = UIView()
        view.layer.opacity = 0.0
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        return view
    }()
    
    internal let loadingIndicatorView: UIActivityIndicatorView = {
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

    internal lazy var profileTableView: UITableView = {
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
        self.configureLoadingView()
        self.fetchUser()
        self.configureObservers()
        self.navigationClearBar()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationClearBar()
    }

    @objc private func fetchUser() {
        self.profileViewModel.configureAccessToken(completion: ) { (completed) in
            DispatchQueue.main.async {
                self.loadingIndicatorView.stopAnimating()
                self.configureTableView()
                self.configureHeaderView()
                self.configureQRCodeView()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func configureObservers() {
        let reloadKey = Notification.Name(Constants.AppActionKeys.profileUpdateKey)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadProfile), name: reloadKey, object: nil)
    }

    @objc func reloadProfile() {
        self.profileViewModel.configureAccessToken(completion: ) { [weak self] (completed) in
            DispatchQueue.main.async {
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
        
        self.profileTableView.refreshControl = refresher
        self.profileTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.profileTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.profileTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func configureQRCodeView() {
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(profileQRCodeBackgroundView)
            window.addSubview(profileQRCodeView)
            self.profileQRCodeView.isHidden = true
            self.profileQRCodeBackgroundView.isHidden = true
            profileQRCodeBackgroundView.frame = CGRect(x: 0, y: window.frame.height + 100, width: window.frame.width, height: window.frame.height)
            profileQRCodeView.frame = CGRect(x: (window.frame.width * 0.5) - 160, y: window.frame.height + 100, width: 320.0, height: 500)
            
        }
    }
    
    internal func editProfileViewController() {
        let profileEditVC = ProfileEditViewController()
        profileEditVC.profleEditViewModel.user = self.profileViewModel.user
        let profileEditNavVC = UINavigationController(rootViewController: profileEditVC)
        self.present(profileEditNavVC, animated: true, completion: nil)
    }
}

extension  ProfileViewController {
    
    func handleShowQRCodeView() {
        self.presentQRCode()
    }
    
    func handleDismissQRCodeView() {
        self.hideQRCode()
    }
    
    private func presentQRCode() {
        
        self.profileQRCodeView.isHidden = false
        self.profileQRCodeBackgroundView.isHidden = false
        
        if let window = UIApplication.shared.keyWindow {
            self.profileQRCodeBackgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.profileQRCodeBackgroundView.layer.opacity = 1.0
                self.profileQRCodeView.frame = CGRect(x: (window.frame.width * 0.5) - 160, y: (window.frame.height * 0.5) - 250, width: 320.0, height: 500)
            }, completion: nil)
        }
    }
    
    
    private func hideQRCode() {
        
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.profileQRCodeBackgroundView.layer.opacity = 0.0
                self.profileQRCodeView.frame = CGRect(x: (window.frame.width * 0.5) - 160, y: window.frame.height + 100, width: 320.0, height: 500)
            }) { (_) in
                self.profileQRCodeView.isHidden = true
                self.profileQRCodeBackgroundView.isHidden = true
                self.profileQRCodeBackgroundView.frame = CGRect(x: 0, y: window.frame.height + 100, width: window.frame.width, height: window.frame.height)
            }
            
        }
    }
}
