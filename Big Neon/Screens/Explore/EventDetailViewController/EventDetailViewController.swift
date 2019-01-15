

import UIKit
import BigNeonUI

internal class EventDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {
    
    internal var eventHeaderView: EventHeaderView = EventHeaderView()
    
    internal lazy var eventTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.white
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    public lazy var getButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Ticket", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        button.backgroundColor = UIColor.brandPrimary
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.configureTableView()
        self.configureHeaderView()
        self.fetchEvent()
    }
    
    private func fetchEvent() {
        self.eventDetailViewModel.fetchEvent { (completed) in
            DispatchQueue.main.async {
                if completed == false {
                    return
                }
                print(self.eventDetailViewModel.eventDetail?.id)
                self.eventTableView.reloadData()
                self.configureButtonView()
            }
        }
    }
    
    private func configureNavBar() {
        self.navigationClearBar()
        self.navigationController?.navigationBar.tintColor = UIColor(white: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(white: 1.0, alpha: 0.0)
        self.navigationController?.navigationBar.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
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
        guard let event = self.eventDetailViewModel.event else {
            eventTableView.tableHeaderView = eventHeaderView
            return
        }
        eventHeaderView.event = event
        eventTableView.tableHeaderView = eventHeaderView
    }
    
    private func configureTableView() {
        self.view.addSubview(eventTableView)
        
        eventTableView.register(EventDetailCell.self, forCellReuseIdentifier: EventDetailCell.cellID)
        eventTableView.register(EventTimeAndLocationCell.self, forCellReuseIdentifier: EventTimeAndLocationCell.cellID)
        
        self.eventTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.eventTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.eventTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.eventTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func configureButtonView() {
        self.view.addSubview(getButton)
        
        self.getButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.getButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.getButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.getButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
 
        if scrollView.contentOffset.y >= 0 {
            self.eventHeaderView.eventImageTopAnchor?.constant = -scrollView.contentOffset.y * -0.5
        }
        
        let distanceToScroll: CGFloat = 350.0
        var offSet = scrollView.contentOffset.y / distanceToScroll
        if offSet > 1 {
            offSet = 1
            self.navigationController?.navigationBar.tintColor = UIColor(white: offSet - 1, alpha: 1.0)
            self.navigationController?.navigationBar.barTintColor = UIColor(white: 1.0, alpha: offSet)
            self.navigationController?.navigationBar.backgroundColor = UIColor(white: 1.0, alpha: offSet)
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(white: 1.0, alpha: offSet)
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor(white: 1.0 - offSet, alpha: 1.0)
            self.navigationController?.navigationBar.barTintColor = UIColor(white: 1.0, alpha: offSet)
            self.navigationController?.navigationBar.backgroundColor = UIColor(white: 1.0, alpha: offSet)
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(white: 1.0, alpha: offSet)
        }
    }
}
