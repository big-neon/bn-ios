


import Foundation
import UIKit
import Big_Neon_UI

public class CheckoutView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    internal lazy var checkoutTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.allowsSelection = true
        tableView.separatorColor = UIColor.brandGrey.withAlphaComponent(0.3)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(checkoutTableView)
        
        checkoutTableView.register(QuantitySelectionCell.self, forCellReuseIdentifier: QuantitySelectionCell.cellID)
        checkoutTableView.register(EventCheckoutDetailCell.self, forCellReuseIdentifier: EventCheckoutDetailCell.cellID)
        checkoutTableView.register(CardCheckoutCell.self, forCellReuseIdentifier: CardCheckoutCell.cellID)
        checkoutTableView.register(SubTotalCell.self, forCellReuseIdentifier: SubTotalCell.cellID)
        checkoutTableView.register(CheckoutTotalCell.self, forCellReuseIdentifier: CheckoutTotalCell.cellID)
        
        self.checkoutTableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.checkoutTableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.checkoutTableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.checkoutTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckoutView {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let quantitySelectionCell: QuantitySelectionCell = tableView.dequeueReusableCell(withIdentifier: QuantitySelectionCell.cellID, for: indexPath) as! QuantitySelectionCell
            return quantitySelectionCell
        case 1:
            let eventDetailCell: EventCheckoutDetailCell = tableView.dequeueReusableCell(withIdentifier: EventCheckoutDetailCell.cellID, for: indexPath) as! EventCheckoutDetailCell
            return eventDetailCell
        case 2:
            let eventDetailCell: CardCheckoutCell = tableView.dequeueReusableCell(withIdentifier: CardCheckoutCell.cellID, for: indexPath) as! CardCheckoutCell
            return eventDetailCell
        case 3:
            let subTotalCell: SubTotalCell = tableView.dequeueReusableCell(withIdentifier: SubTotalCell.cellID, for: indexPath) as! SubTotalCell
            return subTotalCell
        default:
            let totalCell: CheckoutTotalCell = tableView.dequeueReusableCell(withIdentifier: CheckoutTotalCell.cellID, for: indexPath) as! CheckoutTotalCell
            return totalCell
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 110
        }
        
        if indexPath.row == 3 {
            return 130
        }
        
        return 90
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
