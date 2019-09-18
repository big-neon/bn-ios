
import Foundation
import Big_Neon_Core
import Big_Neon_UI
import Alamofire
import SwiftKeychainWrapper

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
    case networkUnavailable = 101
    case wrongDataFormat = 102
}

public class EventsApiRepository {
    
    private init() {}
    public static let shared = EventsApiRepository()
    private let APIURL = APIService.getCheckins()
    
    private func configureAccessToken(completion: @escaping(Bool) -> Void) {
        
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(completed)
                return
            }
        
            completion(true)
        }
    }
    
    private func fetchNewAccessToken(completion: @escaping(Bool) -> Void) {
        
        TokenService.shared.fetchNewAccessToken { (error, tokens) in
            guard let tokens = tokens, (error != nil) else {
                completion(false)
                return
            }
            
            TokenService.shared.saveTokensInKeychain(token: tokens)
            completion(true)
        }
    }
    
    public func fetchEvents(completion: @escaping (_ fetchedEventsDict: [[String: Any]]?, _ error: Error?) -> ()) {
        
        self.configureAccessToken { (completed) in
            if completed == false {
                completion(nil, nil)
                return
            }
            
            let accessToken =  TokenService.shared.fetchAcessToken()
            AF.request(self.APIURL,
                       method: HTTPMethod.get,
                       parameters: nil,
                       encoding: JSONEncoding.default,
                       headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
                .validate(statusCode: 200..<300)
                .response { (response) in
                    
                    if let err = response.error {
                        let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                        completion(nil, error)
                    }
                    
                    guard let data = response.data else {
                        let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                        completion(nil, error)
                        return
                    }
                    
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        guard let jsonDictionary = jsonObject as? [String: Any],
                            let result = jsonDictionary["data"] as? [[String: Any]] else {
                                throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                        }
                        
                        completion(result, nil)
                    } catch let error as NSError {
                        completion(nil, error)
                    }
            }
        }
        
    }

}
