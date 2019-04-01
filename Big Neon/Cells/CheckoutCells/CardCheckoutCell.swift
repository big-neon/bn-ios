
import Foundation
import UIKit

final public class CardCheckoutCell: UITableViewCell {
    
    public static let cellID = "CardCheckoutCellID"
    
    public let paymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let visaCardView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_visaCard")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "**** **** **** 4455"
        label.textColor = UIColor.brandPrimary
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.accessoryType = .disclosureIndicator
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(paymentLabel)
        self.addSubview(visaCardView)
        self.addSubview(cardNumberLabel)
        
        self.paymentLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.paymentLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.paymentLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.paymentLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.visaCardView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.visaCardView.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: 14).isActive = true
        self.visaCardView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.visaCardView.widthAnchor.constraint(equalToConstant: 38).isActive = true
        
        self.cardNumberLabel.leftAnchor.constraint(equalTo: visaCardView.rightAnchor, constant: 14).isActive = true
        self.cardNumberLabel.centerYAnchor.constraint(equalTo: visaCardView.centerYAnchor).isActive = true
        self.cardNumberLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.cardNumberLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
