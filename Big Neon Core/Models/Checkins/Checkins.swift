

import Foundation

public enum EventType: String, Codable {
    case conference     = "Conference"
    case music          = "Music"
}

enum Status: String, Codable {
    case published = "Published"
}


public struct Checkins: Codable {
    let data: [Checkin]
    let paging: Paging
}

public struct Checkin: Codable {
    let id, name, organizationID, venueID: String
    let createdAt, eventStart, doorTime: String
    let status: Status
    let publishDate: String
    let redeemDate: String?
    let feeInCents: Int
    let promoImageURL: String
    let additionalInfo: String?
    let ageLimit: Int
    let topLineInfo, cancelledAt: String?
    let updatedAt: String
    let videoURL: String?
    let isExternal: Bool
    let externalURL: String?
    let overrideStatus: String?
    let clientFeeInCents, companyFeeInCents: Int
    let settlementAmountInCents: Int?
    let eventEnd: String
    let sendgridListID: String?
    let eventType: EventType
    let coverImageURL: String?
    let privateAccessCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case organizationID = "organization_id"
        case venueID = "venue_id"
        case createdAt = "created_at"
        case eventStart = "event_start"
        case doorTime = "door_time"
        case status
        case publishDate = "publish_date"
        case redeemDate = "redeem_date"
        case feeInCents = "fee_in_cents"
        case promoImageURL = "promo_image_url"
        case additionalInfo = "additional_info"
        case ageLimit = "age_limit"
        case topLineInfo = "top_line_info"
        case cancelledAt = "cancelled_at"
        case updatedAt = "updated_at"
        case videoURL = "video_url"
        case isExternal = "is_external"
        case externalURL = "external_url"
        case overrideStatus = "override_status"
        case clientFeeInCents = "client_fee_in_cents"
        case companyFeeInCents = "company_fee_in_cents"
        case settlementAmountInCents = "settlement_amount_in_cents"
        case eventEnd = "event_end"
        case sendgridListID = "sendgrid_list_id"
        case eventType = "event_type"
        case coverImageURL = "cover_image_url"
        case privateAccessCode = "private_access_code"
    }
}
