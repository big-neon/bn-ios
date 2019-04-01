
import UIKit
import PWSwitch
import Big_Neon_UI

public protocol ScannerModeViewDelegate {
    func scannerSetAutomatic()
    func scannerSetManual()
}

public class ScannerModeView: UIView {
    
    internal var changeModeSwitch: PWSwitch?
    public var delegate: ScannerModeViewDelegate?
    
    public var setAutoMode: Bool = false {
        didSet {
            if setAutoMode == false {
                self.changeModeSwitch?.setOn(false, animated: true)
                self.modeLabel.text = "Manual"
                self.modeLabel.textColor = UIColor.brandGreen
                return
            }
            self.changeModeSwitch?.setOn(true, animated: true)
            self.modeLabel.text = "Auto"
            self.modeLabel.textColor = UIColor.brandPrimary
        }
    }
    
    internal let headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Check-in Mode:"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal let modeLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.textColor = UIColor.brandPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.layer.cornerRadius = 20.0
        self.configurePWSwitch()
        self.configureCellView()
    }
    
    private func configurePWSwitch() {
        changeModeSwitch = PWSwitch(frame: CGRect(x: UIScreen.main.bounds.width - 160, y: 6, width: 60, height: 30))
        changeModeSwitch?.shouldFillOnPush = true
        changeModeSwitch?.cornerRadius = 15
        changeModeSwitch?.thumbDiameter = 24.0
        
        //    Off State
        changeModeSwitch?.trackOffBorderColor = UIColor.brandGreen
        changeModeSwitch?.trackOffFillColor = UIColor.brandGreen
        changeModeSwitch?.thumbOffBorderColor = UIColor.white
        changeModeSwitch?.thumbOffFillColor = UIColor.white
        
        //    Pressed State
        changeModeSwitch?.trackOffPushBorderColor = UIColor.brandLightGrey
        changeModeSwitch?.thumbOffPushBorderColor = UIColor.white
        
        //    On State
        changeModeSwitch?.trackOnFillColor = UIColor.brandPrimary
        changeModeSwitch?.trackOnBorderColor = UIColor.brandPrimary
        changeModeSwitch?.thumbOnFillColor = UIColor.white
        changeModeSwitch?.thumbOnBorderColor = UIColor.white
        
        changeModeSwitch?.addTarget(self, action: #selector(stateChanged), for: UIControl.Event.valueChanged)
        addSubview(changeModeSwitch!)
    }
    
    private func configureCellView() {
        self.addSubview(headerLabel)
        self.addSubview(modeLabel)
        
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive  = true
        headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        modeLabel.leftAnchor.constraint(equalTo: headerLabel.rightAnchor, constant: 2.0).isActive  = true
        modeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        modeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        modeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
    
    }
    
    @objc private func stateChanged(switchState: PWSwitch) {
        if switchState.on {
            self.setAutoMode = true
            self.delegate?.scannerSetAutomatic()
        } else {
            self.setAutoMode = false
            self.delegate?.scannerSetManual()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
