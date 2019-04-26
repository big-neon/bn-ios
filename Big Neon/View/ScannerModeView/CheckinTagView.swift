import UIKit

// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar

public class CheckinTagView: UIView {
    
    // lazy?
    public let tagLabel: UILabel = {
        let label = UILabel()
        label.text = "BANNED".uppercased()
        label.textColor = UIColor.brandWhite
        label.textAlignment = .center
        // idea: add font extension for all used fonts and sizes in project
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.brandPrimary
        self.configureView()
    }
    
    public override func layoutSubviews() {
        self.roundCorners([UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 8.0)
    }
    
    private func configureView() {
        self.addSubview(tagLabel)
        
        tagLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        tagLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tagLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tagLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
