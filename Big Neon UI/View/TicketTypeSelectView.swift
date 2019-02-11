

import Foundation
import UIKit

public protocol TicketTypeSelectDelegate {
    func handleSelectTypeType()
}

public class TicketTypeSelectView: UIView {
    
    public var delegate: TicketTypeSelectDelegate?
    public var isOpen: Bool? {
        didSet {
            guard let isOpen = self.isOpen else {
                return
            }
            
            if isOpen == true {
                self.getButton.setTitle("Purhcase Ticket", for: UIControl.State.normal)
                self.headerLabel.isHidden = false
            } else {
                self.getButton.setTitle("Get Ticket", for: UIControl.State.normal)
                self.headerLabel.isHidden = true
            }
        }
    }
    
    public lazy var getButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        button.backgroundColor = UIColor.brandPrimary
        button.addTarget(self, action: #selector(handleSelectButton), for: UIControl.Event.touchUpInside)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleSelectButton), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal let headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Ticket Type"
        label.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.black)
        label.textColor = UIColor.brandBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.brandBlack.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3.0
//        self.roundCorners([UIRectCorner.topLeft, UIRectCorner.topRight,], radius: 5.0)
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(headerLabel)
        self.addSubview(getButton)
        
        getButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        getButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        getButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive  = true
        headerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive  = true
        headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc private func handleSelectButton() {
        self.delegate?.handleSelectTypeType()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
