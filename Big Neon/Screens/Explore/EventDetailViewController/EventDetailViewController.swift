

import UIKit
import Big_Neon_UI

internal class EventDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, TicketTypeSelectDelegate  {
    
    internal var eventHeaderView: EventHeaderView = EventHeaderView()
    internal var getTicketButtonTopAnchor: NSLayoutConstraint?
    private let kTableViewHeaderHeight: CGFloat = 440.0
    private var ticketIsSelected: Bool = false
    
    internal lazy var eventTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.white
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 90.0, right: 0.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    internal lazy var ticketTypeView: TicketTypeSelectView = {
        let view = TicketTypeSelectView()
        view.delegate = self
        view.isOpen = false
        return view
    }()
    
    internal lazy var backgroundDarkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.configureTableView()
        self.configureButtonView()
        self.configureHeaderView()
        self.fetchEvent()
    }
    
    private func fetchEvent() {
        self.eventDetailViewModel.fetchEvent { (completed) in
            DispatchQueue.main.async {
                if completed == false {
                    return
                }
                self.eventTableView.reloadData()
                self.animateGetTicketButton()
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
        frame.size.height = kTableViewHeaderHeight
        eventHeaderView.frame = frame
    }
    
    private func configureHeaderView() {
        eventHeaderView  = EventHeaderView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: kTableViewHeaderHeight))
        guard let event = self.eventDetailViewModel.event else {
            eventTableView.tableHeaderView = eventHeaderView
            return
        }
        eventHeaderView.event = event
        eventTableView.tableHeaderView = eventHeaderView
    }
    
    private func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableViewHeaderHeight, width: eventTableView.bounds.width, height: kTableViewHeaderHeight)
        if eventTableView.contentOffset.y < -kTableViewHeaderHeight {
            headerRect.origin.y = eventTableView.contentOffset.y
            headerRect.size.height = -eventTableView.contentOffset.y
        }
        eventHeaderView.frame = headerRect
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
        self.view.addSubview(backgroundDarkView)
        self.view.addSubview(ticketTypeView)
        
        self.backgroundDarkView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.ticketTypeView.frame = CGRect(x: 0.0, y: self.view.bounds.height, width: self.view.bounds.width, height: 52)
        
        self.backgroundDarkView.layer.opacity = 0.0
        self.backgroundDarkView.isHidden = true
    }
    
    @objc private func animateGetTicketButton() {
        self.ticketTypeView.getButton.setTitle("", for: UIControl.State.normal)
        UIView.animate(withDuration: 0.4, animations: {
            self.ticketTypeView.frame = CGRect(x: 0.0, y: self.view.bounds.height - 52.0, width: self.view.bounds.width, height: 52)
            self.view.layoutIfNeeded()
        }) { (completed) in
            if self.eventDetailViewModel.eventDetail?.isExternal == false && self.eventDetailViewModel.eventDetail?.externalURL == nil {
                self.ticketTypeView.getButton.setTitle("Get Ticket", for: UIControl.State.normal)
            } else {
                self.ticketTypeView.getButton.setTitle("Get Tickets via Web", for: UIControl.State.normal)
            }
        }
    }
    
    func handleSelectTypeType() {
        self.backgroundDarkView.isHidden = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            if self.ticketIsSelected == false {
                self.ticketTypeView.frame = CGRect(x: 0.0, y: self.view.bounds.height - 520, width: self.view.bounds.width, height: 520)
                self.backgroundDarkView.layer.opacity = 0.5
            } else {
                self.ticketTypeView.frame = CGRect(x: 0.0, y: self.view.bounds.height - 52.0, width: self.view.bounds.width, height: 52)
                self.backgroundDarkView.layer.opacity = 0.0
            }
            self.view.layoutIfNeeded()
        }) { (completed) in
            self.ticketIsSelected = !self.ticketIsSelected
            self.ticketTypeView.isOpen = self.ticketIsSelected
        }
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
