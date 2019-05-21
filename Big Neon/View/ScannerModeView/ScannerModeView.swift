
import UIKit
import PWSwitch
import Big_Neon_UI

public class ScannerModeView: UIView {
    
    weak var delegate: ScannerViewDelegate?
    
    var setAutoMode: Bool = false {
        didSet {
            if setAutoMode == false {
                self.changeModeSwitch.setOn(false, animated: true)
                self.modeLabel.text = "Manual"
                self.modeLabel.textColor = UIColor.brandPrimary
                return
            }
            self.changeModeSwitch.setOn(true, animated: true)
            self.modeLabel.text = "Auto"
            self.modeLabel.textColor = UIColor.brandGreen
        }
    }
    
    lazy var changeModeSwitch: UISwitch = {
        let modeSwitch = UISwitch()
        modeSwitch.thumbTintColor = UIColor.white
        modeSwitch.tintColor = UIColor.brandPrimary
        modeSwitch.addTarget(self, action: #selector(stateChanged), for: UIControl.Event.valueChanged)
        modeSwitch.translatesAutoresizingMaskIntoConstraints = false
        return modeSwitch
    }()
    
    lazy var headerLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.text = "Check-in Mode:"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     lazy var modeLabel: BrandTitleLabel = {
        let label = BrandTitleLabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.textColor = UIColor.brandPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerLabel, modeLabel, changeModeSwitch])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 3.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.configureCellView()
    }
    
    private func configureCellView() {
        addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive  = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive  = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive  = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive  = true
    }
    
    @objc private func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
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
