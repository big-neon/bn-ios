
import Foundation

public struct TicketPricing: Codable {
    public let id, name, status, startDate: String
    public let endDate: String
    public let priceInCents, feeInCents, discountInCents: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, status
        case startDate = "start_date"
        case endDate = "end_date"
        case priceInCents = "price_in_cents"
        case feeInCents = "fee_in_cents"
        case discountInCents = "discount_in_cents"
    }
}
