
import Foundation

public struct Events: Codable {
    public var data: [Event]
    public let paging: Paging
}
