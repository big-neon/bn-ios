
import Foundation
import UIKit
import Big_Neon_UI

// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: internal is default access level - not need for explicit definition
// MARK: use abbreviation / syntax sugar

public class ExploreNavigationView: UIView {
    
    // lazy?
    internal let headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Explore"
        label.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.black)
        label.textColor = UIColor.brandBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.configureCellView()
    }
    
    private func configureCellView() {
        self.addSubview(headerLabel)
        
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive  = true
        headerLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive  = true
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
