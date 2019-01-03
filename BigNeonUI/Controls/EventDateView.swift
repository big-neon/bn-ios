

import Foundation
import UIKit

public class EventDateView: UIView {
    
    public let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "jan"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "22"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.layer.cornerRadius = 4.0
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(monthLabel)
        self.addSubview(dateLabel)
        
        monthLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        monthLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        monthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        monthLabel.heightAnchor.constraint(equalToConstant: 13)
        
        dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 22)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
