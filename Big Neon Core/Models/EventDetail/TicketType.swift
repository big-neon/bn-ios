
import Foundation

public struct TicketType: Codable {
    public let id, name: String
    public let description: String?
    public let status: String
    public let available: Int
    public let startDate, endDate: String
    public let increment, limitPerPerson: Int
    public let ticketPricing: TicketPricing?
    public let redemptionCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, status, available
        case startDate = "start_date"
        case endDate = "end_date"
        case increment
        case limitPerPerson = "limit_per_person"
        case ticketPricing = "ticket_pricing"
        case redemptionCode = "redemption_code"
    }
}
