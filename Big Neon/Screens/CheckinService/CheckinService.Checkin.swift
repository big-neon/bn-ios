

import Foundation
import Big_Neon_Core


extension CheckinService {
    
    func completeCheckin(ticket: RedeemableTicket,completion: @escaping(ScanFeedback) -> Void) {
        
        guard let eventID = self.scanVC?.event?.id else {
            completion(.issueFound)
            return
        }
        
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(.issueFound)
                return
            }
         
            BusinessService.shared.database.redeemTicket(forTicketID: ticket.id, eventID: eventID, redeemKey: ticket.redeemKey) { [weak self] (scanFeedback, ticket) in
                DispatchQueue.main.async {
                    self?.redeemedTicket = ticket
                    completion(scanFeedback)
                }
            }
        }
    }
    
    func automaticallyCheckin(ticketID: String, eventID: String?, completion: @escaping(ScanFeedback?, String?, RedeemableTicket?) -> Void) {
        BusinessService.shared.database.getRedeemTicket(forTicketID: ticketID) { (scanFeedback, errorString, redeemTicket) in
            DispatchQueue.main.async {
            
                self.scanVC?.scannedTicket = redeemTicket
                if scanFeedback == .validTicketID {
                    guard let ticket = redeemTicket else {
                        AnalyticsService.reportError(errorType: ErrorType.scanning, error: errorString ?? "")
                        completion(.ticketNotFound, errorString, redeemTicket)
                        return
                    }
                    
                    if !DateConfig.eventDateIsToday(eventStartDate: ticket.eventStart) {
                        completion(.notEventDate, nil, redeemTicket)
                        return
                    }
                    
                    if self.scanVC?.event?.id == nil && eventID == nil {
                        AnalyticsService.reportError(errorType: ErrorType.scanning, error: errorString ?? "")
                        completion(.issueFound, errorString, redeemTicket)
                        return
                    }
                    
                    let eventID = self.scanVC?.event?.id ?? eventID
                    
                    self.completeAutoCheckin(eventID: eventID!, ticket: ticket, completion: { (scanFeedback, checkedInTicket) in
                        AnalyticsService.reportError(errorType: ErrorType.scanning, error: errorString ?? "")
                        completion(scanFeedback, errorString, ticket)
                        return
                    })
                } else {
                    completion(scanFeedback, errorString, redeemTicket)
                }
            }
        }
    }
    
    func completeAutoCheckin(eventID: String, ticket: RedeemableTicket, completion: @escaping(ScanFeedback, RedeemableTicket?) -> Void) {
        
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(.issueFound, ticket)
                return
            }
        
            self.completeCheckin(eventID: eventID, ticket: ticket) { (scanFeedback, ticket) in
                completion(scanFeedback, ticket)
            }
        }
    }

    func completeCheckin(eventID: String, ticket: RedeemableTicket, completion: @escaping(ScanFeedback, RedeemableTicket?) -> Void) {
        
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(.issueFound, ticket)
                return
            }
        
            BusinessService.shared.database.redeemTicket(forTicketID: ticket.id, eventID: eventID, redeemKey: ticket.redeemKey) { [weak self] (scanFeedback, ticket) in
                DispatchQueue.main.async {
                    self?.redeemedTicket = ticket
                    completion(scanFeedback, ticket)
                }
            }
        }
    }
    
}
