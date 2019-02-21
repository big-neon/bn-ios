

import Foundation

public enum EventType: String, Codable {
    case conference     = "Conference"
    case music          = "Music"
}

public enum Status: String, Codable {
    case published = "Published"
}


public struct Checkins: Codable {
    public let data: [Checkin]
    public let paging: Paging
}

public struct Checkin: Codable {
    public let id, name, organizationID, venueID: String
    public let createdAt, eventStart, doorTime: String
    public let status: Status
    public let publishDate: String
    public let redeemDate: String?
    public let feeInCents: Int
    public let promoImageURL: String
    public let additionalInfo: String?
    public let ageLimit: Int
    public let topLineInfo, cancelledAt: String?
    public let updatedAt: String
    public let videoURL: String?
    public let isExternal: Bool
    public let externalURL: String?
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
    
    public func compressImage(url: String, quality: String = "low") -> String {
        //  Only manipulate urls served from cloudinary
        if !url.contains("res.cloudinary.com") {
            return url;
        }
        
        let compressedUrl = url.replacingOccurrences(of: "/image/upload", with: "/image/upload/f_auto/q_auto:"+quality);
        return compressedUrl;
    }
    
//    public func priceTag() -> String {
//        if self.minTicketPrice == nil && self.maxTicketPrice == nil {
//            return ""
//        }
//
//        let minDollars = self.minTicketPrice!
//        let maxDollars = self.maxTicketPrice!
//        var text = "$\(minDollars / 100) - $\(maxDollars / 100)";
//
//        if self.minTicketPrice == self.maxTicketPrice {
//            text = "$\(minDollars / 100)"
//        }
//
//        return text
//    }

}
