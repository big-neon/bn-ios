

import Foundation
import Big_Neon_Core
import Big_Neon_UI
import Alamofire
import SwiftKeychainWrapper

public class GuestsApiRepository {
    
    private init() {}
    static let shared = GuestsApiRepository()
    private let APIURL = APIService.getCheckins()
    
    private func configureAccessToken(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.checkTokenExpirationAndUpdate { (tokenResult, error) in
            if error != nil {
                print(error)
                completion(false)
                return
            }
            
            switch tokenResult {
            case .noAccessToken?:
               print("No Access Token Found")
               completion(false)
            case .tokenExpired?:
                print("Token has expired")
                completion(false)
            default:
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
    
    func fetchGuests(forEventID eventID: String, completion: @escaping (_ fetchedGuestsDict: [[String: Any]]?, _ error: Error?) -> ()) {
        let apiURL = APIService.fetchEvents(eventID: eventID, changesSince: nil, page: nil, limit: nil, query: nil)
        let accessToken = BusinessService.shared.database.fetchAcessToken()
        
        AF.request(apiURL,
                   method: HTTPMethod.get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
            .validate(statusCode: 200..<300)
            .response { (response) in
                
                guard response.result.isSuccess else {
                    completion(nil, response.result.error)
                    AnalyticsService.reportError(errorType: ErrorType.guestsFetch, error: response.result.error!.localizedDescription)
                    return
                }
                
                guard let data = response.result.value else {
                    let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                    AnalyticsService.reportError(errorType: ErrorType.guestsFetch, error: error.localizedDescription)
                    completion(nil, nil)
                    return
                }
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    guard let jsonDictionary = jsonObject as? [String: Any],
                        let result = jsonDictionary["data"] as? [[String: Any]] else {
                            throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                    }
                    
//                    let pagingDictionary = jsonDictionary["paging"] as? [String: Any]
//                    let totalGuests = pagingDictionary!["total"] as! Int
//                    let decoder = JSONDecoder()
//                    let guests = try decoder.decode(Guests.self, from: data!)
                    
                    completion(result, nil)
                    
                } catch let error as NSError {
                    AnalyticsService.reportError(errorType: ErrorType.guestsFetch, error: error.localizedDescription)
                    completion(nil, error)
                }
        }
    }
    
//    func fetchEvents(completion: @escaping (_ fetchedEventsDict: [[String: Any]]?, _ error: Error?) -> ()) {
//
//        self.configureAccessToken { (completed) in
//            if completed == false {
//                completion(nil, nil)
//                return
//            }
//
//            let accessToken = BusinessService.shared.database.fetchAcessToken()
//            AF.request(self.APIURL,
//                       method: HTTPMethod.get,
//                       parameters: nil,
//                       encoding: JSONEncoding.default,
//                       headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
//                .validate(statusCode: 200..<300)
//                .response { (response) in
//
//                    guard response.result.isSuccess else {
//                        let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
//                        completion(nil, error)
//                        return
//                    }
//
//                    guard let data = response.result.value else {
//                        let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
//                        completion(nil, error)
//                        return
//                    }
//
//                    do {
//                        let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
//
//                        guard let jsonDictionary = jsonObject as? [String: Any],
//                            let result = jsonDictionary["data"] as? [[String: Any]] else {
//                                throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
//                        }
//
//                        completion(result, nil)
//                    } catch {
//                        completion(nil, error)
//                    }
//            }
//        }
//
//    }
    
}
