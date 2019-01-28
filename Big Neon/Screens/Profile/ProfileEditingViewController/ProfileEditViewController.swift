


import UIKit
import Big_Neon_UI

internal class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    internal var profleEditViewModel: ProfileEditViewModel = ProfileEditViewModel()
    
    internal lazy var profileEditTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = UIColor.brandBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorColor = UIColor.brandGrey.withAlphaComponent(0.3)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.configureNavBar()
        self.configureAccountTableView()
    }
    
    private func configureNavBar() {
        self.navigationLineBar()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setNavigationTitle(withTitle: "Account", titleColour: UIColor.brandBlack)
        self.navigationController?.navigationBar.tintColor = UIColor.brandPrimary
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(handleSave))
    }
    
    private func configureAccountTableView() {
        self.view.addSubview(profileEditTableView)
        
        profileEditTableView.register(ProfileEditTableCell.self, forCellReuseIdentifier: ProfileEditTableCell.cellID)
        profileEditTableView.register(LogoutCell.self, forCellReuseIdentifier: LogoutCell.cellID)
        
        self.profileEditTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.profileEditTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.profileEditTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.profileEditTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func handleSave() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

