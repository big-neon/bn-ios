

import Foundation

struct LocalizedTimes: Codable {
    let eventStart: String?
    let eventEnd: String?
    let doorTime: String?
    
    enum CodingKeys: String, CodingKey {
        case eventStart = "event_start"
        case eventEnd = "event_end"
        case doorTime = "door_time"
    }
}
