
import Foundation
import Big_Neon_Core
import Big_Neon_UI
import Alamofire
import SwiftKeychainWrapper

public class EventsApiRepository {
    
    private init() {}
    static let shared = EventsApiRepository()
    private let APIURL = APIService.getCheckins()
    
    private func configureAccessToken(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.tokenIsExpired { [weak self] (expired) in
            if expired == true {
                self?.fetchNewAccessToken(completion: { (completed) in
                    completion(completed)
                    return
                })
            } else {
                completion(true)
                return
            }
        }
    }
    
    private func fetchNewAccessToken(completion: @escaping(Bool) -> Void) {
        BusinessService.shared.database.fetchNewAccessToken { [weak self] (error, tokens) in
            guard let tokens = tokens else {
                completion(false)
                return
            }
            
            self?.saveTokensInKeychain(token: tokens)
            completion(true)
        }
    }
    
    private func saveTokensInKeychain(token: Tokens) {
        KeychainWrapper.standard.set(token.accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(token.refreshToken, forKey: "refreshToken")
        return
    }
    
    func fetchEvents(completion: @escaping (_ fetchedEventsDict: [[String: Any]]?, _ error: Error?) -> ()) {
        
        self.configureAccessToken { (completed) in
            if completed == false {
                print("Failed to get a new token in the EventsApiRepository")
                completion(nil, nil)
                return
            }
            
            let accessToken = BusinessService.shared.database.fetchAcessToken()
            AF.request(self.APIURL,
                       method: HTTPMethod.get,
                       parameters: nil,
                       encoding: JSONEncoding.default,
                       headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
                .validate(statusCode: 200..<300)
                .response { (response) in
                    
                    guard response.result.isSuccess else {
                        let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                        completion(nil, error)
                        return
                    }
                    
                    guard let data = response.result.value else {
                        let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                        completion(nil, error)
                        return
                    }
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                        
                        guard let jsonDictionary = jsonObject as? [String: Any],
                            let result = jsonDictionary["data"] as? [[String: Any]] else {
                                throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                        }
                        
                        completion(result, nil)
                    } catch {
                        completion(nil, error)
                    }
            }
        }
        
    }
    
}
