
import Foundation

public struct RedeemedTicket: Codable {
    public let id, ticketType, userID, orderID: String
    public let orderItemID: String
    public let priceInCents: Int
    public let firstName, lastName, email, phone: String
    public let redeemKey: String
    public let redeemDate: String?
    public let status, eventID, eventName, doorTime: String
    public let eventStart, venueID, venueName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ticketType     = "ticket_type"
        case userID         = "user_id"
        case orderID        = "order_id"
        
        case orderItemID    = "order_item_id"
        case priceInCents   = "price_in_cents"
        case firstName      = "first_name"
        case lastName       = "last_name"
        case email
        case phone
        case redeemKey      = "redeem_key"
        case redeemDate     = "redeem_date"
        case status
        case eventID        = "event_id"
        case eventName      = "event_name"
        case doorTime       = "door_time"
        case eventStart     = "event_start"
        case venueID        = "venue_id"
        case venueName      = "venue_name"
    }
}
