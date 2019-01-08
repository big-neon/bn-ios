
import Foundation

public struct Events: Codable {
    let data: [Event]
    let paging: Paging
}
