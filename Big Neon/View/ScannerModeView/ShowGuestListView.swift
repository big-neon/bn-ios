

import UIKit
import PWSwitch
import Big_Neon_UI

public class ShowGuestListView: UIView {
    
    lazy var headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Show Guest List"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.textColor = UIColor.brandGrey
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = UIActivityIndicatorView.Style.gray
        loader.tintColor = UIColor.brandPrimary
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerLabel, loadingView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.loadingView.startAnimating()
        self.configureView()
    }
    
    private func configureView() {
        addSubview(stackView)
    
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
