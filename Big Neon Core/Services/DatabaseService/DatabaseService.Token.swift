import Foundation
import Alamofire
import JWTDecode
import SwiftKeychainWrapper

public enum TokenExpResult {
    case noAccessToken
    case tokenExpired
    case tokenRefreshed
    case tokenNotExpired
}

extension DatabaseService {
    
    public func checkTokenExpirationAndUpdate(completion: @escaping (TokenExpResult?, Error?) -> Void) {
        
        guard let accessToken = self.fetchAcessToken() else {
            
            self.updateAccessToken { (error) in
                if let err = error {
                    completion(nil, err)
                    return
                }
                completion(.tokenRefreshed, nil)
            }
            return
        }
        
        do {
            let jwt = try decode(jwt: accessToken)
            let _ = jwt.expired
            guard let tokenExpiryDate = jwt.expiresAt else {
                completion(.noAccessToken, nil)
                return
            }

            if tokenExpiryDate < Date.init(timeInterval: 60, since: Date()) {
                self.updateAccessToken { (error) in
                    if let err = error {
                        completion(nil, err)
                        return
                    }
                    completion(.tokenRefreshed, nil)
                    return
                }
            } else {
                completion(.tokenNotExpired, nil)
                return
            }
            
        } catch let error as NSError {
            print(error)
            completion(.noAccessToken, error)
        }
    }
    
    public func updateAccessToken(completion: @escaping(Error?) -> Void) {
        self.fetchNewAccessToken { (error, tokens) in
            if let err = error {
                completion(err)
                return
            }
            
            if let tokens = tokens {
                self.saveTokensInKeychain(token: tokens)
                print(tokens)
            }
            completion(nil)
        }
    }

    public func fetchNewAccessToken(completion: @escaping (Error?, Tokens?) -> Void) {

        guard let refreshToken = self.fetchRefreshToken() else {
            completion(nil, nil)
            return
        }

        let authParameters = ["refresh_token": refreshToken]
        let APIURL = APIService.refreshToken()
        
        AF.request(APIURL,
                        method: HTTPMethod.post,
                        parameters: authParameters,
                        encoding: JSONEncoding.default,
                        headers: [:])
                .validate()
                .response { (response) in

                    guard response.result.isSuccess else {
                        completion(response.result.error, nil)
                        return
                    }

                    guard let data = response.result.value else {
                        completion(nil, nil)
                        return
                    }

                    do {
                        let decoder = JSONDecoder()
                        let tokens = try decoder.decode(Tokens.self, from: data!)
                        completion(nil, tokens)
                        return
                    } catch let error as NSError {
                        completion(error, nil)
                    }

                }
    }
}
