
import Foundation
import UIKit

public class SectionHeaderCell: UICollectionViewCell {
    
    public static let cellID = "SectionHeaderCellID"
    
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
