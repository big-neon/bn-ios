

import Foundation

public enum EventType: String, Codable {
    case conference     = "Conference"
    case music          = "Music"
}

public struct Event: Codable {
    public let id: String?
    public let name: String?
    public let organizationID: String?
    public let venueID: String?
    public let createdAt: String?
    public let eventStart: String?
    public let doorTime: String?
    public let status: String?
    public let publishDate: String?
    public let promoImageURL: String?
    public let additionalInfo: String?
    public let topLineInfo: String?
    public let ageLimit: Int?
    public let cancelledAt: String?
    public let venue: Venue?
    public let minTicketPrice :Int?
    public let maxTicketPrice: Int?
    public let isExternal: Bool?
    public let externalURL: String?
    public let userIsInterested: Bool?
    public let localizedTimes: LocalizedTimes?
    
    //  Checkins Parameters 
    public let redeemDate: String?
    public let feeInCents: Int?
    public let updatedAt: String?
    public let videoURL: String?
    public let overrideStatus: String?
    public let clientFeeInCents, companyFeeInCents: Int
    public let settlementAmountInCents: Int?
    public let eventEnd: String
    public let sendgridListID: String?
    public let eventType: EventType
    public let coverImageURL: String?
    public let privateAccessCode: String?

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
        case redeemDate = "redeem_date"
        case feeInCents = "fee_in_cents"
        case updatedAt = "updated_at"
        case videoURL = "video_url"
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
    
    public func compressImage(url: String, quality: String = "low") -> String {
        //  Only manipulate urls served from cloudinary
        if !url.contains("res.cloudinary.com") {
            return url;
        }
        
        let compressedUrl = url.replacingOccurrences(of: "/image/upload", with: "/image/upload/f_auto/q_auto:"+quality);
        return compressedUrl;
    }
    
    public func priceTag() -> String {
        if self.minTicketPrice == nil && self.maxTicketPrice == nil {
            return ""
        }
        
        let minDollars = self.minTicketPrice!
        let maxDollars = self.maxTicketPrice!
        var text = "$\(minDollars / 100) - $\(maxDollars / 100)";
        
        if self.minTicketPrice == self.maxTicketPrice {
            text = "$\(minDollars / 100)"
        }
        
        return text
    }

}


