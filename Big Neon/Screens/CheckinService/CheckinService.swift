

import Foundation
import Big_Neon_Core
import CoreData
import Sync

class CheckinService {
    
    var scannedMetaString: String?
    var redeemedTicket: RedeemableTicket?
    var lastRedeemedTicket: RedeemableTicket?
    var scanVC: ScannerViewController?
    var guests: Guests?
    
    var totalGuests: Int?
    var currentTotalGuests: Int = 0
    var currentPage: Int = 0
    let limit = 100
    var ticketsFetched: [RedeemableTicket] = []
    var ticketsCoreData: [GuestData] = []

    //  Event Infor
    var eventID: String?
    
}
