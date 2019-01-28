
import Foundation

public struct User: Codable {
    public let id: String?
    public let firstName: String?
    public let lastName: String?
    public let email: String?
    public let phone: String?
    public let profilePicURL: String?
    public let thumbProfilePicURL: String?
    public let coverPhotoURL: String?
    public let isOrgOwner: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case profilePicURL = "profile_pic_url"
        case thumbProfilePicURL = "thumb_profile_pic_url"
        case coverPhotoURL = "cover_photo_url"
        case isOrgOwner = "is_org_owner"
    }
}


public struct UserOrg: Codable {
    public let user: User?
    public let roles: [String]?
    public let scopes: [String]?
    public let organizationRoles: [String: [String]]?
    public let organizationScopes: [String: [String]]?

    enum CodingKeys: String, CodingKey {
        case user, roles, scopes
        case organizationRoles = "organization_roles"
        case organizationScopes = "organization_scopes"
    }
}
