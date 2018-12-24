

import UIKit
import BigNeonUI

internal class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    internal var profileHeaderView                  = ProfileHeaderView()
    internal let picker                             = UIImagePickerController()
    
    internal lazy var profileTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = UIColor.brandBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.brandGrey.withAlphaComponent(0.5)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.configureNavBar()
        self.configureTableView()
        self.configureHeaderView()
    }
    
    private func configureNavBar() {
        self.navigationNoLineBar()
        self.navigationController?.navigationBar.tintColor = UIColor.brandPrimary
        self.navigationController?.navigationBar.barTintColor = UIColor.white
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
        profileTableView.tableHeaderView = profileHeaderView
    }
    
    private func configureTableView() {
        self.view.addSubview(profileTableView)
        
        profileTableView.register(ProfileTableCell.self, forCellReuseIdentifier: ProfileTableCell.cellID)
        
        self.profileTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.profileTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.profileTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
