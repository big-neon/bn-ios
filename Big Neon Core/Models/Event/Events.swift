
import Foundation

public struct Events: Codable {
    public let data: [Event]
    public let paging: Paging
}
