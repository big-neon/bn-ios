


import UIKit
import PanModal
import Big_Neon_UI
import Big_Neon_Core

extension GuestViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
}

final class GuestViewController: UIViewController {
    
    lazy var guestProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.brandPrimary
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var guestNameLabel: UILabel = {
       let label = UILabel()
       label.text = "Toby McGuire"
       label.textColor = UIColor.brandBlack
       label.textAlignment = .center
       label.font = UIFont.boldSystemFont(ofSize: 18)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()

    var detailLabel: UILabel = {
       let label = UILabel()
       label.text = "Your published and upcoming events will be found here."
       label.textAlignment = .center
       label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
       label.textColor = UIColor.brandGrey
       label.numberOfLines = 0
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureImageView()
    }
    
    private func configureImageView() {
        view.addSubview(guestProfileImageView)
//        view.addSubview(guestNameLabel)
//        view.addSubview(guestProfileImageView)
        
        guestProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guestProfileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        guestProfileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        guestProfileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true

    }
    
}
