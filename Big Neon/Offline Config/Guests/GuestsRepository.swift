

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
        
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(false)
                return
            }
        
            completion(true)
            return
        }
    }
    
    private func fetchNewAccessToken(completion: @escaping(Bool) -> Void) {
        TokenService.shared.fetchNewAccessToken { (error, tokens) in
            guard let tokens = tokens else {
                completion(false)
                return
            }
            
            TokenService.shared.saveTokensInKeychain(token: tokens)
            completion(true)
        }
    }
    
    private func saveTokensInKeychain(token: Tokens) {
        KeychainWrapper.standard.set(token.accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(token.refreshToken, forKey: "refreshToken")
        return
    }
    
    public func fetchGuests(forEventID eventID: String, limit: Int, page: Int?, guestQuery: String?, completion: @escaping (_ error: Error?, _ fetchedGuestsDict: [[String: Any]]?, _ serverGuests: Guests?, _ totalGuests: Int) -> Void) {
        
        let apiURL = APIService.fetchEvents(eventID: eventID, changesSince: nil, page: page, limit: limit, query: guestQuery)
        guard let accessToken = TokenService.shared.fetchAcessToken() else {
            completion(nil, nil, nil, 0)
            return
        }
        
        AF.request(apiURL,
                   method: HTTPMethod.get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken)"])
            .validate(statusCode: 200..<300)
            .response { (response) in
                
                if let err = response.error {
                    completion(err, nil, nil, 0)
                    return
                }
                
                guard let data = response.data else {
                    completion(nil, nil, nil, 0)
                    return
                }
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let jsonDictionary = jsonObject as? [String: Any],
                        let result = jsonDictionary["data"] as? [[String: Any]] else {
                            throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                    }
                    
                    let pagingDictionary = jsonDictionary["paging"] as? [String: Any]
                    let totalGuests = pagingDictionary!["total"] as! Int
                    let decoder = JSONDecoder()
                    let guests = try decoder.decode(Guests.self, from: data)
                    completion(nil, result, guests, totalGuests)
                    
                } catch let error as NSError {
                    print(error)
                    completion(error, nil, nil, 0)
                }
        }
    }

}

