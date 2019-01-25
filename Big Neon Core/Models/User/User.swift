
import Foundation

public struct User: Codable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let phone: String?
    let profilePicURL: String?
    let thumbProfilePicURL: String?
    let coverPhotoURL: String?
    let isOrgOwner: Bool?
    
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
    let user: User?
    let roles: [String]?
    let scopes: [String]?
    let organizationRoles: [String: [String]]?
    let organizationScopes: [String: [String]]?

    enum CodingKeys: String, CodingKey {
        case user, roles, scopes
        case organizationRoles = "organization_roles"
        case organizationScopes = "organization_scopes"
    }
}
