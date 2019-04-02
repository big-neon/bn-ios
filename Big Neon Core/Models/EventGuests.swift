
import Foundation

public struct Guests: Codable {
    public let data: [RedeemableTicket]
    public let paging: Paging
    
    public enum CodingKeys: String, CodingKey {
        case data, paging
    }
}
