

import Foundation

public struct Event: Codable {
    public let id: String
    public let name: String
    public let organizationID: String
    public let venueID: String
    public let createdAt: String
    public let eventStart: String
    public let doorTime: String
    public let status: String
    public let publishDate: String
    public let promoImageURL: String
    public let additionalInfo: String?
    public let topLineInfo: String?
    public let ageLimit: Int
    public let cancelledAt: String?
    public let venue: Venue
    public let minTicketPrice :Int?
    public let maxTicketPrice: Int?
    public let isExternal: Bool
    public let externalURL: String?
    public let userIsInterested: Bool
    public let localizedTimes: LocalizedTimes
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case organizationID = "organization_id"
        case venueID = "venue_id"
        case createdAt = "created_at"
        case eventStart = "event_start"
        case doorTime = "door_time"
        case status
        case publishDate = "publish_date"
        case promoImageURL = "promo_image_url"
        case additionalInfo = "additional_info"
        case topLineInfo = "top_line_info"
        case ageLimit = "age_limit"
        case cancelledAt = "cancelled_at"
        case venue
        case minTicketPrice = "min_ticket_price"
        case maxTicketPrice = "max_ticket_price"
        case isExternal = "is_external"
        case externalURL = "external_url"
        case userIsInterested = "user_is_interested"
        case localizedTimes = "localized_times"
    }
}
