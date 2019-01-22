
import Foundation

public struct EventDetail: Codable {
    public let id: String
    public let name: String
    public let organizationID: String
    public let venueID: String
    public let createdAt: String
    public let eventStart: String
    public let doorTime: String
    public let eventEnd: String
    public let feeInCents: Int
    public let status: String
    public let publishDate: String
    public let promoImageURL: String
    public let additionalInfo: String
    public let topLineInfo: String
    public let ageLimit: Int
    public let videoURL: String?
    public let organization: Organization
    public let venue: Venue
    public let artists: [PerformingArtist]
    public let ticketTypes: [TicketType]
    public let totalInterest: Int
    public let userIsInterested: Bool
    public let minTicketPrice: Int
    public let maxTicketPrice: Int
    public let isExternal: Bool
    public let externalURL: String?
    public let overrideStatus: String?
    public let limitedTicketsRemaining: [Int]
    public let localizedTimes: LocalizedTimes
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case organizationID = "organization_id"
        case venueID = "venue_id"
        case createdAt = "created_at"
        case eventStart = "event_start"
        case doorTime = "door_time"
        case eventEnd = "event_end"
        case feeInCents = "fee_in_cents"
        case status
        case publishDate = "publish_date"
        case promoImageURL = "promo_image_url"
        case additionalInfo = "additional_info"
        case topLineInfo = "top_line_info"
        case ageLimit = "age_limit"
        case videoURL = "video_url"
        case organization, venue, artists
        case ticketTypes = "ticket_types"
        case totalInterest = "total_interest"
        case userIsInterested = "user_is_interested"
        case minTicketPrice = "min_ticket_price"
        case maxTicketPrice = "max_ticket_price"
        case isExternal = "is_external"
        case externalURL = "external_url"
        case overrideStatus = "override_status"
        case limitedTicketsRemaining = "limited_tickets_remaining"
        case localizedTimes = "localized_times"
    }
}

