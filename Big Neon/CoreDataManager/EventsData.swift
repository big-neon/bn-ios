
import UIKit
import CoreData
import Foundation

extension EventsData {

    public func update(with jsonDictionary: [String: Any]) throws {
        guard let id = jsonDictionary["id"] as? String,
            let additionalInfo = jsonDictionary["additional_info"] as? String,
            let ageLimit = jsonDictionary["age_limit"] as? String,
            let cancelledAt = jsonDictionary["cancelled_at"] as? String,
            let clientFeeInCents = jsonDictionary["client_fee_in_cents"] as? Int,
            let companyFeeInCents = jsonDictionary["company_fee_in_cents"] as? Int,
            let createdAt = jsonDictionary["created_at"] as? String,
            let doorTime = jsonDictionary["door_time"] as? String,
            let eventEnd = jsonDictionary["event_end"] as? String,
            let eventStart = jsonDictionary["event_start"] as? String,
            let externalUrl = jsonDictionary["external_url"] as? String,
            let feeInCents = jsonDictionary["fee_in_cents"] as? String,
            let isExternal = jsonDictionary["is_external"] as? Bool,
            let maxTicketPrice = jsonDictionary["max_ticket_price"] as? Int,
            let minTicketPrice = jsonDictionary["min_ticket_price"] as? Int,
            let name = jsonDictionary["name"] as? String,
            let organizationID = jsonDictionary["organization_id"] as? String,
            let overrideStatus = jsonDictionary["override_status"] as? String,
            let privateAccessCode = jsonDictionary["private_access_code"] as? String,
            let promoImageUrl = jsonDictionary["promo_image_url"] as? String,
            let publishDate = jsonDictionary["publish_date"] as? String,
            let redeemDate = jsonDictionary["redeem_date"] as? String,
            let sendgridListID = jsonDictionary["sendgrid_list_id"] as? String,
            let settlementAmountInCents = jsonDictionary["settlement_amount_in_cents"] as? Int,
            let status = jsonDictionary["status"] as? String,
            let toplineinfo = jsonDictionary["top_line_info"] as? String,
            let updatedAt = jsonDictionary["updated_at"] as? String,
            let userIsInterested = jsonDictionary["user_is_interested"] as? String,
            let venueID = jsonDictionary["venue_id"] as? String,
            let videoURL = jsonDictionary["video_url"] as? String
        
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        self.id                 = id
        self.additional_info    = additionalInfo
        self.age_limit          = ageLimit
        self.cancelled_at       = cancelledAt
        self.client_fee_in_cents = Int64(Int(truncatingIfNeeded: clientFeeInCents))
        self.company_fee_in_cents = Int64(Int(truncatingIfNeeded: companyFeeInCents))
        self.created_at         = createdAt
        self.door_time          = doorTime
        self.event_end          = eventEnd
        self.event_start        = eventStart
        self.external_url       = externalUrl
        self.fee_in_cents       = feeInCents
        self.is_external        = isExternal
        self.max_ticket_price   = Int64(Int(truncatingIfNeeded: maxTicketPrice))
        self.min_ticket_price   = Int64(Int(truncatingIfNeeded: minTicketPrice))
        self.name               = name
        self.organization_id    = organizationID
        self.override_status    = overrideStatus
        self.private_access_code = privateAccessCode
        self.promo_image_url    = promoImageUrl
        self.publish_date       = publishDate
        self.redeem_date        = redeemDate
        self.sendgrid_list_id   = sendgridListID
        self.settlement_amount_in_cents  = Int64(Int(truncatingIfNeeded: settlementAmountInCents))
        self.status             = status
        self.top_line_info      = toplineinfo
        self.updated_at         = updatedAt
        self.user_is_interested = userIsInterested
        self.venue_id           = venueID
        self.video_url          = videoURL
    }

}
