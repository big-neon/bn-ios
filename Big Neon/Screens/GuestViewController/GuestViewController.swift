


import UIKit
import PanModal
import Big_Neon_UI
import Big_Neon_Core
import TransitionButton
import AVFoundation

extension GuestViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(410)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
}

class GuestViewController: BaseViewController {
    
    var event: EventsData?
    var guestListVC: EventViewController?
    var scannerVC: ScannerViewController?
    var scannerViewModel = CheckinService()
    var guestListIndex: IndexPath?
    var audioPlayer: AVAudioPlayer?
    weak var delegate: ScannerViewDelegate?
    
    var guest: GuestData? {
        didSet {
            guard let guest = self.guest else {
                return
            }
            
            self.userNameLabel.text = guest.first_name! + " " + guest.last_name!
            self.ticketTypeLabel.text = guest.event_name!
            let price = Int(guest.price_in_cents)
            let ticketID = "#" + guest.id!.suffix(8).uppercased()
            ticketTypeLabel.text = price.dollarString + " | " + guest.ticket_type! + " | " + ticketID
            if let phone = guest.phone {
                ticketEmailPhoneLabel.text = guest.email ?? "" + " " + phone
            } else {
                ticketEmailPhoneLabel.text = guest.email ?? ""
            }
            
            
            
            if guest.status == TicketStatus.purchased.rawValue {
                ticketTagView.backgroundColor = UIColor.brandGreen
                ticketTagView.tagLabel.text = "PURCHASED"
                completeCheckinButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                completeCheckinButton.backgroundColor = .brandPrimary
                completeCheckinButton.setTitle("Complete Check-in", for: UIControl.State.normal)
                completeCheckinButton.addTarget(self, action: #selector(handleCompleteCheckin), for: UIControl.Event.touchUpInside)
                
            } else { 
                
                //  Ticket Redeemed
                ticketTagView.tagLabel.text = "REDEEMED"
                ticketTagView.backgroundColor = UIColor.brandBlack
                completeCheckinButton.backgroundColor = .brandBackground
                completeCheckinButton.setTitleColor(UIColor.brandLightGrey, for: UIControl.State.normal)
                completeCheckinButton.setTitle("Redeemed", for: UIControl.State.normal)
                completeCheckinButton.isUserInteractionEnabled = false

                if let redemeedBy = guest.redeemed_by {
                    redeemedByLabel.text = "By: " + redemeedBy
                    completeCheckinButton.isHidden = true
                }
                
                ticketTypeLabel.text = price.dollarString + " | " + guest.ticket_type! + " | " + ticketID
                
                guard let timezone = event?.venue, let redeemDate = guest.redeemed_at else {
                    return
                }

                guard let redeemedDate = DateConfig.formatServerDate(date: redeemDate, timeZone: timezone.timezone!) else {
                    return
                }

                redeemedTimeAgoLabel.text = "Redeemed: " + redeemedDate.getElapsed()
                redeemedTimeLabel.text = DateConfig.fullDateFormat(date: redeemedDate)
            }
            
            self.enableCheckinButton()
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
       label.textAlignment = .center
       label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
    lazy var ticketEmailPhoneLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
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
    
    lazy var redeemedTimeAgoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var redeemedByLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var redeemedTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
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
        scannerVC?.stopScanning = true
        configureView()
        enableCheckinButton()
    }
    
    func enableCheckinButton() {
        
        if let ticket = self.guest {
            if DateConfig.eventDateIsToday(eventStartDate: ticket.event_start!) == true {
                return
            }
            
            completeCheckinButton.setTitleColor(UIColor.brandLightGrey, for: UIControl.State.normal)
            completeCheckinButton.backgroundColor = UIColor.brandBackground
            completeCheckinButton.setTitle("Not Event Date", for: UIControl.State.normal)
            completeCheckinButton.isUserInteractionEnabled = false
        }
    }
    
    private func configureView() {
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(ticketTypeLabel)
        view.addSubview(ticketEmailPhoneLabel)
        view.addSubview(ticketTagView)
        
        view.addSubview(lineView)
        view.addSubview(redeemedTimeAgoLabel)
        view.addSubview(redeemedTimeLabel)
        view.addSubview(completeCheckinButton)
        view.addSubview(redeemedByLabel)
        
        userImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutSpec.Spacing.twentyFour).isActive = true
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
        
        ticketEmailPhoneLabel.topAnchor.constraint(equalTo: ticketTypeLabel.bottomAnchor, constant: LayoutSpec.Spacing.eight).isActive = true
        ticketEmailPhoneLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        ticketEmailPhoneLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        ticketEmailPhoneLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twenty).isActive = true
        
        ticketTagView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ticketTagView.topAnchor.constraint(equalTo: ticketEmailPhoneLabel.bottomAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        ticketTagView.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true
        ticketTagView.widthAnchor.constraint(equalToConstant: 88).isActive = true

        lineView.topAnchor.constraint(equalTo: ticketTagView.bottomAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        lineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.9).isActive = true
        
        redeemedTimeAgoLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: LayoutSpec.Spacing.thirtyTwo).isActive = true
        redeemedTimeAgoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        redeemedTimeAgoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        redeemedTimeAgoLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true
        
        redeemedTimeLabel.topAnchor.constraint(equalTo: redeemedTimeAgoLabel.bottomAnchor, constant: LayoutSpec.Spacing.twelve).isActive = true
        redeemedTimeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        redeemedTimeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        redeemedTimeLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twenty).isActive = true
        
        redeemedByLabel.topAnchor.constraint(equalTo: redeemedTimeLabel.bottomAnchor, constant: LayoutSpec.Spacing.twelve).isActive = true
        redeemedByLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        redeemedByLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        redeemedByLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twenty).isActive = true
        
        //  Completed
        completeCheckinButton.topAnchor.constraint(equalTo: redeemedTimeLabel.bottomAnchor, constant: LayoutSpec.Spacing.eight).isActive = true
        completeCheckinButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        completeCheckinButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        completeCheckinButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
    }
    
    @objc func handleCompleteCheckin() {
        self.completeCheckinButton.startAnimation()
        self.completeCheckin()
    }
    
    func completeCheckin() {
    
        guard let ticketID = self.guest?.id else {
            return
        }
        
        let fromGuestListVC = guestListVC == nil ? false : true
        self.scannerViewModel.automaticallyCheckin(ticketID: ticketID, eventID: self.event?.id) { [weak self] (scanFeedback, errorString, ticket) in
            DispatchQueue.main.async {
                
                guard let self = self else { return }
                
                //  Stop Animating the Button
                self.completeCheckinButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0) {
                    self.completeCheckinButton.layer.cornerRadius = 6.0
                    
                    //  Update the Redeemed Ticket
                    //  self.guest = ticket
                    self.guest?.status = ticket?.status
                    
                    //  Checking from Guestlist
                    if fromGuestListVC == true {
                        self.reloadGuestList(ticketID: ticketID)
                        self.playSuccessSound(forValidTicket: true)
                        self.generator.notificationOccurred(.success)
                        return
                    }
                    
                    self.dismissController()
                    self.scannerVC?.showScannedUser(feedback: scanFeedback, ticket: ticket)
                    
                }
            }
        }
    }
    
    func panModalWillDismiss() {
        self.scannerVC?.isShowingScannedUser = false
        self.scannerVC?.lastScannedTicketTime = nil
        self.scannerVC?.scannerViewModel?.lastRedeemedTicket = nil
    }
    
    func playSuccessSound(forValidTicket valid: Bool) {
        let sound = valid == true ? "Valid" : "Redeemed"
        if let resourcePath =  Bundle.main.path(forResource: sound, ofType: "m4a") {
            let url = URL(fileURLWithPath: resourcePath)
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
    }
    
    //  Reload the Cells in the Guest List
    func reloadGuestList(ticketID: String) {
        
        guard let indexPath = guestListIndex else {
            return
        }
        
        if self.guestListVC?.isSearching == true {
            self.guestListVC?.eventViewModel.guestCoreDataSearchResults.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
            self.reloadGuestCells(atIndexPath: indexPath)
        } else {
            self.guestListVC?.eventViewModel.guestCoreData.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
            self.reloadGuestCells(atIndexPath: indexPath)
        }
    }
    
    func reloadGuestCells(atIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let guestCell: EventGuestsCell = self.guestListVC?.guestTableView.cellForRow(at: indexPath) as! EventGuestsCell
        guestCell.ticketStateView.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0) {
            guestCell.ticketStateView.layer.cornerRadius = 3.0
            guestCell.ticketStateView.setTitle("REDEEMED", for: UIControl.State.normal)
            guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
        }

    }
    
    @objc func doNothing() {
        print("Already Redeemed")
    }
    
    
}
