
import Foundation
import UIKit

// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar
// MARK: internal is default access level - not need for explicit definition

public class SectionHeaderCell: UICollectionViewCell {
    
    public static let cellID = "SectionHeaderCellID"
    
    // lazy?
    public let sectionHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.text = "Hot This Week"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(sectionHeaderLabel)

        sectionHeaderLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sectionHeaderLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sectionHeaderLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sectionHeaderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
