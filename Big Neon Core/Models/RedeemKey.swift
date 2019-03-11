
import Foundation

public struct RedeemKey: Codable {
    public let type: Int
    public let data: RedeemKeyData
    
    enum CodingKeys: String, CodingKey {
        case type
        case data
    }
}

public struct RedeemKeyData: Codable {
    public let redeemKey, id, extra: String
//    enum CodingKeys: String, CodingKey {
//        case redeem_key
//        case id
//        case extra
//    }
}
