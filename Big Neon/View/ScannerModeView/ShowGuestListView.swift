

import UIKit
import PWSwitch
import Big_Neon_UI

public class ShowGuestListView: UIView {
    
    lazy var headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Show Guest List"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.textColor = UIColor.brandPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var loading: UIActivity
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.configureView()
    }
    
    private func configureView() {
        addSubview(headerLabel)
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive  = true
        headerLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive  = true
        headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive  = true
        headerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
