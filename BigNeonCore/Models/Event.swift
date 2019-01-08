

import Foundation

struct Event: Codable {
    let id: String
    let name: String
    let organizationID: String
    let venueID: String
    let createdAt: String
    let eventStart: String
    let doorTime: String
    let status: String
    let publishDate: String
    let promoImageURL: String
    let additionalInfo: String?
    let topLineInfo: String?
    let ageLimit: Int
    let cancelledAt: String?
    let venue: Venue
    let minTicketPrice :Int?
    let maxTicketPrice: Int?
    let isExternal: Bool
    let externalURL: String?
    let userIsInterested: Bool
    let localizedTimes: LocalizedTimes
    
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
