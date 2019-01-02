

import UIKit
import BigNeonUI

internal class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    internal var eventHeaderView: EventHeaderView = EventHeaderView()
    internal var profileViewModel: ProfileViewModel = ProfileViewModel()
    internal let picker                             = UIImagePickerController()
    
    internal lazy var eventTableView: UITableView = {
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
        self.configureTableView()
        self.configureHeaderView()
    }
    
    private func configureNavBar() {
        self.navigationClearBar()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sizeHeaderToFit()
    }
    
    private func sizeHeaderToFit() {
        eventHeaderView.setNeedsLayout()
        eventHeaderView.layoutIfNeeded()
        var frame = eventHeaderView.frame
        frame.size.height = CGFloat(470.0)
        eventHeaderView.frame = frame
    }
    
    private func configureHeaderView() {
        eventHeaderView  = EventHeaderView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 470.0))
        eventTableView.tableHeaderView = eventHeaderView
    }
    
    private func configureTableView() {
        self.view.addSubview(eventTableView)
        
        eventTableView.register(ProfileTableCell.self, forCellReuseIdentifier: ProfileTableCell.cellID)
        
        self.eventTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.eventTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.eventTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.eventTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
