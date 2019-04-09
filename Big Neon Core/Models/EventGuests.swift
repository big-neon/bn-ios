
import Foundation

public struct Guests: Codable {
    public var data: [RedeemableTicket]
    public let paging: Paging
    
    public enum CodingKeys: String, CodingKey {
        case data, paging
    }
}
