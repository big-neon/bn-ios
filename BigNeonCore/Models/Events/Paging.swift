
import Foundation

public struct Paging: Codable {
    public let page: Int
    public let limit: Int
    public let sort: String
    public let dir: String
    public let total: Int
    public let tags: Tags
}

public struct Tags: Codable {
    
}
