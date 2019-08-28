


import UIKit
import PanModal
import Big_Neon_UI
import Big_Neon_Core
import TransitionButton

extension GuestViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(360)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
}

final class GuestViewController: UIViewController {
    
    weak var delegate: ScannerViewDelegate?
    var event: EventsData?
    var redeemableTicket: RedeemableTicket? {
        didSet {
            guard let ticket = self.redeemableTicket else {
                return
            }
            
            print(ticket)
            self.userNameLabel.text = ticket.firstName
            self.ticketTypeLabel.text = ticket.eventName
//            self.redeemedByLabel.text = ticket.eventName
            let price = Int(ticket.priceInCents)
            let ticketID = "#" + ticket.id.suffix(8).uppercased()
            ticketTypeLabel.text = price.dollarString + " | " + ticket.ticketType + " | " + ticketID
            
            if ticket.status == TicketStatus.purchased.rawValue {
                ticketTagView.backgroundColor = UIColor.brandGreen
                ticketTagView.tagLabel.text = "PURCHASED"
                completeCheckinButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                completeCheckinButton.backgroundColor = .brandPrimary
                completeCheckinButton.setTitle("Complete Check-in", for: UIControl.State.normal)
                completeCheckinButton.addTarget(self, action: #selector(handleCompleteCheckin), for: UIControl.Event.touchUpInside)
                
            } else {
                //  Ticket had been redeemed
                
                ticketTagView.tagLabel.text = "REDEEMED"
                ticketTagView.backgroundColor = UIColor.brandBlack
                completeCheckinButton.backgroundColor = .brandBackground
                completeCheckinButton.setTitleColor(UIColor.brandLightGrey, for: UIControl.State.normal)
                completeCheckinButton.setTitle("Already Redeemed", for: UIControl.State.normal)
                completeCheckinButton.addTarget(self, action: #selector(doNothing), for: UIControl.Event.touchUpInside)

                if let redemeedBy = ticket.redeemedBy {
                    redeemedByLabel.text = "Redeemed by: " + redemeedBy
                }
                
                ticketTypeLabel.text = price.dollarString + " | " + ticket.ticketType + " | " + ticketID
                
                guard let timezone = event?.venue, let redeemDate = ticket.redeemedAt else {
                    ticketTypeLabel.text = "No Date Captured"
                    return
                }

                guard let redeemedDate = DateConfig.formatServerDate(date: redeemDate, timeZone: timezone.timezone!) else {
                    ticketTypeLabel.text = "No Date Captured"
                    return
                }

                ticketTypeLabel.text = "Redeemed: " + redeemedDate.getElapsed()

            }
        }
    }
       
   public lazy var userImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage(named: "empty_profile")
       imageView.contentMode = .scaleAspectFill
       imageView.clipsToBounds = true
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }()
   
   lazy var userNameLabel: UILabel = {
       let label = UILabel()
       label.text = "User Name"
       label.textAlignment = .center
       label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   
   lazy var ticketTypeLabel: UILabel = {
       let label = UILabel()
       label.textAlignment = .center
       label.textColor = UIColor.brandGrey
       label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   
   lazy var ticketTagView: CheckinTagView = {
       let view = CheckinTagView()
       view.backgroundColor = UIColor.brandBackground
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
   }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brandGrey.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var redeemedByLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var completeCheckinButton: TransitionButton = {
        let button = TransitionButton()
        button.layer.cornerRadius = 4.0
        button.setTitleColor(UIColor.brandWhite, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureView()
    }
    
    private func configureView() {
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(ticketTypeLabel)
        view.addSubview(ticketTagView)
        
        view.addSubview(lineView)
        view.addSubview(redeemedByLabel)
        view.addSubview(completeCheckinButton)
        
        userImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutSpec.Spacing.thirtyTwo).isActive = true
        userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true
        
        ticketTypeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: LayoutSpec.Spacing.eight).isActive = true
        ticketTypeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        ticketTypeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        ticketTypeLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twenty).isActive = true
        
        ticketTagView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ticketTagView.topAnchor.constraint(equalTo: ticketTypeLabel.bottomAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        ticketTagView.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true
        ticketTagView.widthAnchor.constraint(equalToConstant: 88).isActive = true

        lineView.topAnchor.constraint(equalTo: ticketTagView.bottomAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        lineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.9).isActive = true
        
        redeemedByLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: LayoutSpec.Spacing.twenty).isActive = true
        redeemedByLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        redeemedByLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        redeemedByLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true
        
        //  Completed
        completeCheckinButton.topAnchor.constraint(equalTo: redeemedByLabel.bottomAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        completeCheckinButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        completeCheckinButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        completeCheckinButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    @objc func handleCompleteCheckin() {
//        self.completeCheckinButton.startAnimation()
//        self.delegate?.completeCheckin()
    }
    
    @objc func doNothing() {
        print("Already Redeemed")
    }
    
    
}
