

import Foundation
import UIKit
import PresenterKit
import Big_Neon_UI
import Big_Neon_Core

extension TicketTypeViewController {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ticketTypes = self.ticketTypeViewModel.eventDetail?.ticketTypes else {
            return 0
        }
        return ticketTypes.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ticketTypeCell: TicketTypeCell = tableView.dequeueReusableCell(withIdentifier: TicketTypeCell.cellID, for: indexPath) as! TicketTypeCell
        guard let ticketTypes = self.ticketTypeViewModel.eventDetail?.ticketTypes else {
            return ticketTypeCell
        }
        let ticketType = ticketTypes[indexPath.row]
        ticketTypeCell.ticketType  = ticketType
        ticketTypeCell.ticketTypeStatus   = ticketType.status
        return ticketTypeCell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
