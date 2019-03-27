
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation 

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    @objc internal func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showGuestList() {
        self.isShowingGuests = !self.isShowingGuests
    }
    
    func scannerSetAutomatic() {
        self.scannerViewModel.setCheckingModeAutomatic()
    }
    
    func scannerSetManual() {
        self.scannerViewModel.setCheckingModeManual()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        self.hideScannedUser()
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            print("No QR data detected")
            self.scanCompleted = true
            return
        }
        
        if self.scanCompleted == true {
            return
        }
        
        if supportedCodeTypes.contains(metadataObj.type) {
            guard let metaDataString = metadataObj.stringValue else {
                self.generator.notificationOccurred(.error)
                self.scanCompleted = true
                return
            }
            
            guard self.scannerViewModel.getRedeemKey(fromStringValue: metaDataString) != nil else {
                self.generator.notificationOccurred(.error)
                Utils.showAlert(presenter: self, title: "No Redeem Key Found", message: "The ticket does not contain a redeem key. Check the guest in from the guest list")
                self.scanCompleted = true
                return
            }
            
            guard let ticketID = self.scannerViewModel.getTicketID(fromStringValue: metaDataString) else {
                self.generator.notificationOccurred(.error)
                self.scanCompleted = true
                return
            }
            
            if self.scannerViewModel.scannerMode() == true {
                self.checkinAutomatically(withTicketID: ticketID)
            } else {
                self.checkinManually(withTicketID: ticketID)
            }
            
        }
    }
    
    private func checkinAutomatically(withTicketID ticketID: String) {
        self.scannerViewModel.automaticallyChecking(ticketID: ticketID) { (scanFeedback) in
            switch scanFeedback {
            case .alreadyRedeemed:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .alreadyRedeemed
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
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .issueFound
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    Utils.showAlert(presenter: self, title: "Ticket Not Found", message: "We could not find the redeemable ticket you scanned. Check the guest in from the guest list")
                    self.dismissFeedbackView(feedback: scanFeedback)
                })
                return
            case .wrongEvent:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .wrongEvent
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView(feedback: scanFeedback)
                })
                return
            default:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .valid
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView(feedback: scanFeedback)
                })
                return
            }
        }
    }
    
    private func checkinManually(withTicketID ticketID: String) {
        self.scannerViewModel.getRedeemTicket(ticketID: ticketID) { (scanFeedback) in
            switch scanFeedback {
            case .alreadyRedeemed?:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .alreadyRedeemed
                    self.scannerModeView.layer.opacity = 0.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.scanCompleted = true
                })
            case .issueFound?:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .issueFound
                    self.scannerModeView.layer.opacity = 0.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.scanCompleted = true
                })
            case .wrongEvent?:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .wrongEvent
                    self.scannerModeView.layer.opacity = 0.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.scanCompleted = true
                })
            case .validTicketID?:
                self.scanCompleted = false
                self.showRedeemedTicket()
            default:
                print("No Ticket Data")
                self.scanCompleted = true
                return
            }
        }
    }
    
    private func showRedeemedTicket() {
        if self.scanCompleted == true {
            return
        }
        self.scanCompleted = true
        self.generator.notificationOccurred(.success)
        self.manualUserCheckinView.redeemableTicket = self.scannerViewModel.redeemableTicket
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.feedbackView.layer.contentsScale = 1.0
            self.blurView?.layer.opacity = 1.0
            self.scannerModeView.layer.opacity = 0.0
            self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height - 250.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.scanCompleted = true
        })
    }
    
    internal func completeCheckin() {
        self.scannerViewModel.completeCheckin { (scanFeedback) in
            
            switch scanFeedback {
            case .alreadyRedeemed:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .alreadyRedeemed
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
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .issueFound
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    Utils.showAlert(presenter: self, title: "Ticket Not Found", message: "We could not find the redeemable ticket you scanned. Check the guest in from the guest list")
                    self.dismissFeedbackView(feedback: scanFeedback)
                })
                return
            case .wrongEvent:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .wrongEvent
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView(feedback: scanFeedback)
                })
                return
            default:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .valid
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView(feedback: scanFeedback)
                })
                return
            }
        }
    }
    
    private func dismissFeedbackView(feedback: ScanFeedback) {
        UIView.animate(withDuration: 0.8, delay: 1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurView?.layer.opacity = 0.0
            self.feedbackView.layer.opacity = 0.0
            self.scannerModeView.layer.opacity = 1.0
            self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            if feedback == .valid {
                self.presentScannedUser()
            } else {
                self.scanCompleted = true
            }
            
        })
    }
    
    private func presentScannedUser() {
        self.manualUserCheckinView.redeemableTicket = self.scannerViewModel.redeemableTicket
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scannedUserBottomAnchor?.constant = -40.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.scanCompleted = true
        })
    }
    
    private func hideScannedUser() {
        self.manualUserCheckinView.redeemableTicket = nil
        self.scannerViewModel.redeemableTicket = nil
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scannedUserBottomAnchor?.constant = 150.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.scanCompleted = true
        })
    }
    
}
