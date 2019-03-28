

import Foundation
import Alamofire
import SwiftKeychainWrapper

extension DatabaseService {
    
    public func createUser(withEmail email: String, password: String, completion: @escaping (Error?, Tokens?) -> Void) {
        
        let parameters = ["email": email, "password": password]
        
        let APIURL = APIService.users()
        
        AF.request(APIURL,
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: [:])
            .validate(statusCode: 200..<300)
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
                    let tokens = try decoder.decode(Tokens.self, from: data!)
                    completion(nil, tokens)
                    return
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    
    
    public func loginToAccount(withEmail email: String, password: String, completion: @escaping (Error?, Tokens?) -> Void) {
        
        let parameters = ["email": email,
                          "password": password]
        let APIURL = APIService.login()
        
        AF.request(APIURL,
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: [:])
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
                    let tokens = try decoder.decode(Tokens.self, from: data!)
                    completion(nil, tokens)
                    return
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    
    public func logout(completion: @escaping (Bool) -> Void) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "refreshToken")
        completion(true)
        
    }
}
