

import Foundation
import UIKit

public class GuestListView: UIView {

    public let allguestsLabel: UILabel = {
        let label = UILabel()
        label.text = "All Guests"
        label.textColor = UIColor.brandBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 6.0
        self.layer.shadowColor = UIColor.brandBlack.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 9.0)
        self.layer.shadowRadius = 16.0
        self.layer.shadowOpacity = 0.32
        self.configureView()
    }
    
    public override func layoutSubviews() {
        
    }
    
    private func configureView() {
        self.addSubview(allguestsLabel)
        
        allguestsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28).isActive = true
        allguestsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        allguestsLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        allguestsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
