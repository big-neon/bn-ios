

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
                
                if let err = response.error {
                    completion(err, nil)
                    return
                }
                
                guard let data = response.data else {
                    print("Invalid tag information received from the service")
                    completion(nil, nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let tokens = try decoder.decode(Tokens.self, from: data)
                    completion(nil, tokens)
                    return
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    
    
//    fetchEvents(completion: @escaping (_ fetchedEventsDict: [[String: Any]]?, _ error: Error?) -> ())
    public func loginToAccount(withEmail email: String, password: String, completion: @escaping (_ error: String?, _ tokens: Tokens?) -> Void) {
        
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
                
                if let err = response.error {
                    completion(err.localizedDescription, nil)
                    return
                }
                
                do {
                    if let data = response.data {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        guard let jsonDictionary = jsonObject as? [String: Any] else {
                            throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                        }
                        
                        if let error = jsonDictionary["error"] as? String {
                            completion(error, nil)
                        }
                    }
                } catch {
                    print("No Error Found")
                    let error = error.localizedDescription as String
                    completion(error, nil)
                }
                
                guard let data = response.data else {
                    print("Invalid tag information received from the service")
                    completion(nil, nil)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let tokens = try decoder.decode(Tokens.self, from: data)
                    completion(nil, tokens)
                    return
                } catch let error as NSError {
                    let error = error.localizedDescription as String
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
