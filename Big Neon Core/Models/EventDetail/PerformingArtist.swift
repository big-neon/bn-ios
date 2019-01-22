
import Foundation

public struct PerformingArtist: Codable {
    public let eventID: String
    public let artist: Artist
    public let rank: Int
    public let setTime: String?
    
    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case artist, rank
        case setTime = "set_time"
    }
}
