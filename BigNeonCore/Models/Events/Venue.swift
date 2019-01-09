

import Foundation

public struct Venue: Codable {
    public let id: String
    public let regionID: String
    public let organizationID: String?
    public let isPrivate: Bool
    public let name, address, city, state: String
    public let country, postalCode: String
    public let phone: String?
    public let promoImageURL: String?
    public let createdAt, updatedAt: String
    public let googlePlaceID: String?
    public let latitude, longitude: Double?
    public let timezone: String?
    
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
