

import Foundation

struct Venue: Codable {
    let id, regionID: String
    let organizationID: String?
    let isPrivate: Bool
    let name, address, city, state: String
    let country, postalCode: String
    let phone: String?
    let promoImageURL: String?
    let createdAt, updatedAt: String
    let googlePlaceID: String?
    let latitude, longitude: Double?
    let timezone: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case regionID = "region_id"
        case organizationID = "organization_id"
        case isPrivate = "is_private"
        case name, address, city, state, country
        case postalCode = "postal_code"
        case phone
        case promoImageURL = "promo_image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case googlePlaceID = "google_place_id"
        case latitude, longitude, timezone
    }
}
