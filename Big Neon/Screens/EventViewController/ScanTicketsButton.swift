
import UIKit
import Big_Neon_UI
import Big_Neon_Core

class ScanTicketsButton: UIView {
    
    lazy var scanTicketImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_scanImage")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var scanTicketLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Scan Tickets"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var scanStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [scanTicketImage, scanTicketLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8.0
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.brandPrimary
        self.layer.cornerRadius = 28.0
        self.configureView()
    }

    private func configureView() {
        self.addSubview(scanStackView)
        
//        scanStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
//        scanStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        scanStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        scanStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scanStackView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        scanStackView.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
