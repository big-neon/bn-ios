


import Foundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core
import PINRemoteImage

public class HomeSectionCell: UICollectionViewCell {
    
    public static let cellID = "HomeSectionCellCellID"
    
    lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.text = "Upcoming"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.brandBackground
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(sectionLabel)
        
        sectionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        sectionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutSpec.Spacing.twentyFour).isActive = true
        sectionLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.sixteen).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
