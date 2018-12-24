
import Foundation
import UIKit

public class SectionHeaderCell: UICollectionViewCell {
    
    public static let cellID = "SectionHeaderCellID"
    
    public let sectionHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandMediumGrey
        label.text = "Hot This Week"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
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
        sectionHeaderLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        sectionHeaderLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        sectionHeaderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sectionHeaderLabel.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
