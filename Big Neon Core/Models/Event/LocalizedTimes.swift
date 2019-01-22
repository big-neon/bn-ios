

import Foundation

public struct LocalizedTimes: Codable {
    public let eventStart: String?
    public let eventEnd: String?
    public let doorTime: String?
    
    enum CodingKeys: String, CodingKey {
        case eventStart = "event_start"
        case eventEnd = "event_end"
        case doorTime = "door_time"
    }
}
