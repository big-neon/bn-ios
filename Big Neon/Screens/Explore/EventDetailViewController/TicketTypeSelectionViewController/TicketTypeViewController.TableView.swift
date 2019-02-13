

import Foundation
import UIKit
import PresenterKit
import Big_Neon_UI

extension TicketTypeViewController {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ticketTypeCell: TicketTypeCell = tableView.dequeueReusableCell(withIdentifier: TicketTypeCell.cellID, for: indexPath) as! TicketTypeCell
        return ticketTypeCell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
