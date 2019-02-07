
import Foundation

public struct PerformingArtist: Codable {
    public let eventID: String
    public let artist: Artist
    public let rank: Int
    public let setTime: String?
    public let importance: Int
    public let stageID: String?
    
    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case artist, rank
        case setTime = "set_time"
        case importance
        case stageID = "stage_id"
    }
}

public struct Artist: Codable {
    public let id: String
    public let organizationID: String?
    public let isPrivate: Bool
    public let name, bio: String
    public let imageURL, thumbImageURL: String?
    public let websiteURL: String?
    public let youtubeVideoUrls: [String]?
    public let facebookUsername: String?
    public let instagramUsername: String?
    public let snapchatUsername: String?
    public let soundcloudUsername: String?
    public let bandcampUsername: String?
    public let spotifyID: String?
    public let createdAt: String
    public let updatedAt: String?
    public let otherImageUrls: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case organizationID = "organization_id"
        case isPrivate = "is_private"
        case name, bio
        case imageURL = "image_url"
        case thumbImageURL = "thumb_image_url"
        case websiteURL = "website_url"
        case youtubeVideoUrls = "youtube_video_urls"
        case facebookUsername = "facebook_username"
        case instagramUsername = "instagram_username"
        case snapchatUsername = "snapchat_username"
        case soundcloudUsername = "soundcloud_username"
        case bandcampUsername = "bandcamp_username"
        case spotifyID = "spotify_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case otherImageUrls = "other_image_urls"
    }
}

