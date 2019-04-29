
import UIKit
import CoreData
import Foundation

extension EventsData {
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()
    
    public func update(with jsonDictionary: [String: Any]) throws {
        guard let id = jsonDictionary["id"] as? String,
            let additionalInfo = jsonDictionary["additional_info"] as? String,
            let ageLimit = jsonDictionary["age_limit"] as? String,
            let cancelledAt = jsonDictionary["cancelled_at"] as? String,
            let clientFeeInCents = jsonDictionary["client_fee_in_cents"] as? String,
            let companyFeeInCents = jsonDictionary["company_fee_in_cents"] as? String,
            let createdAt = jsonDictionary["created_at"] as? String,
            let doorTime = jsonDictionary["door_time"] as? String,
            let eventEnd = jsonDictionary["event_end"] as? String,
            let eventStart = jsonDictionary["event_start"] as? String,
            let externalUrl = jsonDictionary["external_url"] as? String,
            let feeInCents = jsonDictionary["fee_in_cents"] as? String,
            let isExternal = jsonDictionary["is_external"] as? Bool,
            let maxTicketPrice = jsonDictionary["max_ticket_price"] as? String,
            let minTicketPrice = jsonDictionary["min_ticket_price"] as? String,
            let name = jsonDictionary["name"] as? String,
            let organizationID = jsonDictionary["organization_id"] as? String,
            let overrideStatus = jsonDictionary["override_status"] as? String,
            let privateAccessCode = jsonDictionary["private_access_code"] as? String,
            let promoImageUrl = jsonDictionary["promo_image_url"] as? String,
            let publishDate = jsonDictionary["publish_date"] as? String,
            let redeemDate = jsonDictionary["redeem_date"] as? String,
            let sendgridListID = jsonDictionary["sendgrid_list_id"] as? String,
            let settlementAmountInCents = jsonDictionary["settlement_amount_in_cents"] as? String,
            let status = jsonDictionary["status"] as? String,
            let toplineinfo = jsonDictionary["top_line_info"] as? String,
            let updatedAt = jsonDictionary["updated_at"] as? String,
            let userIsInterested = jsonDictionary["user_is_interested"] as? String,
            let venueID = jsonDictionary["venue_id"] as? String,
            let videoURL = jsonDictionary["video_url"] as? String
        
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        self.id             = id
        self.additionalInfo = additionalInfo
        self.ageLimit       = ageLimit
        self.cancelledAt    = cancelledAt
        self.clientFeeInCents = clientFeeInCents
        self.companyFeeInCents = companyFeeInCents
        self.createdAt      = createdAt
        self.doorTime       = doorTime
        self.eventEnd       = eventEnd
        self.eventStart     = eventStart
        self.externalUrl    = externalUrl
        self.feeInCents     = feeInCents
        self.isExternal         = isExternal
        self.maxTicketPrice     = maxTicketPrice
        self.minTicketPrice     = minTicketPrice
        self.name               = name
        self.organizationID     = organizationID
        self.overrideStatus     = overrideStatus
        self.privateAccessCode  = privateAccessCode
        self.promoImageUrl      = promoImageUrl
        self.publishDate        = publishDate
        self.redeemDate         = redeemDate
        self.sendgridListID     = sendgridListID
        self.settlementAmountInCents  = settlementAmountInCents
        self.status             = status
        self.toplineinfo        = toplineinfo
        self.updatedAt          = updatedAt
        self.userIsInterested   = userIsInterested
        self.venueID            = venueID
        self.videoURL           = videoURL
    }

}
