
import Foundation
import Alamofire

extension DatabaseService {

    public func insert(name: String, lastName: String, completion: @escaping(Error?, User?) -> Void) {
        
        let parameters = ["first_name": name,
                          "last_name": lastName]
        
        let APIURL = APIService.updateUser()
        let accessToken = TokenService.shared.fetchAcessToken()
        
        AF.request(APIURL,
                   method: HTTPMethod.put,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
            .validate()
            .response { (response) in
                
                guard response.result.isSuccess else {
                    completion(response.result.error, nil)
                    return
                }
                
                guard let data = response.result.value else {
                    print("Invalid tag information received from the service")
                    completion(nil, nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userOrg = try decoder.decode(UserOrg.self, from: data!)
                    let user = userOrg.user
                    completion(nil, user)
                    return
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
        
    }
    
    
    public func updateUser(firstName: String, lastName: String, email: String, completion: @escaping(Error?, User?) -> Void) {
        
        let parameters = ["first_name": firstName,
                        "last_name": lastName,
                        "email": email]
        let APIURL = APIService.updateUser()
        let accessToken = TokenService.shared.fetchAcessToken()
        
        AF.request(APIURL,
                   method: HTTPMethod.put,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
            .validate()
            .response { (response) in
                
                guard response.result.isSuccess else {
                    print(response.result.error)
                    completion(response.result.error, nil)
                    return
                }
                
                guard let data = response.result.value else {
                    print("Invalid tag information received from the service")
                    completion(nil, nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userOrg = try decoder.decode(UserOrg.self, from: data!)
                    let user = userOrg.user
                    completion(nil, user)
                    return
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
        
    }
    
    /*
    public func updateUserImage(image: UIImage, lastName: String, email: String, completion: @escaping(Error?) -> Void) {
        
        case profilePicURL = "profile_pic_url"
        case thumbProfilePicURL = "thumb_profile_pic_url"
        
        //  Upload picture
        
        //  Get Url and Update DB
        
        let parameters = ["profile_pic_url": firstName,
                          "thumb_profile_pic_url": lastName]
        let APIURL = APIService.updateUser()
        let accessToken = self.fetchAcessToken()
        
        AF.request(APIURL,
                   method: HTTPMethod.put,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
            .validate()
            .response { (response) in
                
                guard response.result.isSuccess else {
                    print(response.result.error)
                    completion(response.result.error, nil)
                    return
                }
                
                guard let data = response.result.value else {
                    print("Invalid tag information received from the service")
                    completion(nil, nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userOrg = try decoder.decode(UserOrg.self, from: data!)
                    let user = userOrg.user
                    completion(nil, user)
                    return
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    */
    
    public func fetchUser(completion: @escaping(Error?, User?) -> Void) {
        
        let APIURL = APIService.updateUser()
        let accessToken = TokenService.shared.fetchAcessToken()!
        
        AF.request(APIURL,
            method: HTTPMethod.get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: [APIParameterKeys.authorization: "Bearer \(accessToken)"])
            .validate()
            .response { (response) in
                
                guard response.result.isSuccess else {
                    print("Error while fetching user: \(response.result.error)")
                    completion(nil, nil)
                    return
                }
                
                guard let data = response.result.value else {
                    print("Invalid tag information received from the service")
                    completion(nil, nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userOrg = try decoder.decode(UserOrg.self, from: data!)
                    let user = userOrg.user
                    completion(nil, user)
                    return
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
        
    }
    
}
