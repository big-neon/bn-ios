
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation

extension ScannerViewController {
    
    func checkinManually(withTicketID ticketID: String) {
        self.scannerViewModel?.getRedeemTicket(ticketID: ticketID) { [weak self] (scanFeedback, errorString) in
            if scanFeedback == .validTicketID {
                self?.stopScanning = false
                self?.showRedeemedTicket()
                return
            }
            self?.manualCheckinFeedback(scanFeedback: scanFeedback)
        }
    }
    
    func manualCheckinFeedback(scanFeedback: ScanFeedback?) {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scanningBoarderView.layer.opacity = 0.0
            self.showGuestView.layer.opacity = 0.0
            self.blurView?.layer.opacity = 1.0
            self.scannerModeView.layer.opacity = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.stopScanning = false
        })
    }
    
    func showRedeemedTicket() {
        self.scannedTicketID = self.scannedTicket?.id
        self.manualUserCheckinView.redeemableTicket = self.scannedTicket
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scanningBoarderView.layer.opacity = 0.0
            self.showGuestView.layer.opacity = 0.0
            self.closeButton.layer.opacity = 0.0
            self.blurView?.layer.opacity = 1.0
            self.scannerModeView.layer.opacity = 0.0
            self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height - 250.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.stopScanning = true
        })
    }
    
    internal func completeCheckin() {
        
        guard let ticketID = self.scannedTicketID else {
            return
        }
        
        self.scannerViewModel?.automaticallyCheckin(ticketID: ticketID) { (scanFeedback, errorString, ticket) in
            switch scanFeedback {
            case .alreadyRedeemed:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    //                    self.feedbackView.layer.opacity = 1.0
                    //                    self.feedbackView.scanFeedback = .alreadyRedeemed
                    //                    self.feedbackView.errorDetail = errorString
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView(feedback: scanFeedback)
                })
                return
            case .issueFound:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    //                    self.feedbackView.layer.opacity = 1.0
                    //                    self.feedbackView.scanFeedback = .issueFound
                    //                    self.feedbackView.errorDetail = errorString
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    //                    Utils.showAlert(presenter: self, title: "Ticket Not Found", message: "We could not find the redeemable ticket you scanned. Check the guest in from the guest list")
                    self.dismissFeedbackView(feedback: scanFeedback)
                })
                return
            case .wrongEvent:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    //                    self.feedbackView.layer.opacity = 1.0
                    //                    self.feedbackView.scanFeedback = .wrongEvent
                    //                    self.feedbackView.errorDetail = errorString
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView(feedback: scanFeedback)
                })
                return
            default:
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    //                    self.feedbackView.layer.opacity = 0.0
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView(feedback: .valid)
                })
                return
            }
        }
    }
}
