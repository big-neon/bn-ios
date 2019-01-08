
import Foundation

struct Paging: Codable {
    let page, limit: Int
    let sort: String
    let dir: String
    let total: Int
    let tags: Tags
}

struct Tags: Codable {
}
