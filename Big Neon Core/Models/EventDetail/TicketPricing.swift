
import Foundation

public struct TicketPricing: Codable {
    public let id: String
    public let name: String
    public let status: String
    public let startDate: String
    public let endDate: String
    public let priceInCents: Int
    public let feeInCents: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, status
        case startDate = "start_date"
        case endDate = "end_date"
        case priceInCents = "price_in_cents"
        case feeInCents = "fee_in_cents"
    }
}
