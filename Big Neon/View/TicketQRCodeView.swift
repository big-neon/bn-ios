

import Foundation
import UIKit
import Big_Neon_UI

// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar

public protocol TicketQRCodeDelegate {
    func handleDismissQRCodeView()
}

public class TicketQRCodeView: UIView {
    
    // weak?
    public var delegate: TicketQRCodeDelegate?
    
    public let qrCodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    // lazy?
    public let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Share this to accept ticket transfers and invites"
        label.textColor = UIColor.brandBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var gotItButton: BrandButton = {
        let button = BrandButton()
        button.setTitle("GOT IT", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleGotIt), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 6.0
        self.layer.shadowColor = UIColor.brandBlack.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 9.0)
        self.layer.shadowRadius = 16.0
        self.layer.shadowOpacity = 0.32
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(qrCodeImage)
        self.addSubview(detailLabel)
        self.addSubview(gotItButton)
        
        qrCodeImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 48).isActive = true
        qrCodeImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        qrCodeImage.heightAnchor.constraint(equalToConstant: 222).isActive = true
        qrCodeImage.widthAnchor.constraint(equalToConstant: 222).isActive = true
        
        detailLabel.topAnchor.constraint(equalTo: qrCodeImage.bottomAnchor, constant: 44).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        gotItButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 32).isActive = true
        gotItButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60).isActive = true
        gotItButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60).isActive = true
        gotItButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc private func handleGotIt() {
        self.delegate?.handleDismissQRCodeView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
