
import Foundation
import SwiftKeychainWrapper
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

public class TokenService {
    
    public class var shared: TokenService {
        struct Static {
            static let instance: TokenService = TokenService()
        }
        return Static.instance
    }
    
    public func fetchAcessToken() -> String? {
        return KeychainWrapper.standard.string(forKey: Constants.keychainAccessToken)
    }
    
    public func saveTokensInKeychain(token: Tokens) {
        KeychainWrapper.standard.set(token.accessToken, forKey:  Constants.keychainAccessToken)
        KeychainWrapper.standard.set(token.refreshToken, forKey: Constants.keychainRefreshToken)
    }
    
    @discardableResult public func fetchRefreshToken() -> String? {
        return KeychainWrapper.standard.string(forKey: Constants.keychainRefreshToken)
    }
    
    public func checkToken(completion: @escaping(Bool) -> Void) {
        
        self.checkTokenExpirationAndUpdate { (tokenResult, error) in
            if error != nil {
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
            }
        }
        
    }
    
    private func checkTokenExpirationAndUpdate(completion: @escaping (TokenExpResult?, Error?) -> Void) {
        
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
    
    private func updateAccessToken(completion: @escaping(Error?) -> Void) {
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

                    do {
                        guard let dataValue = response.result.value, let data = dataValue else {
                            completion(nil, nil)
                            return
                        }
                        let decoder = JSONDecoder()
                        let tokens = try decoder.decode(Tokens.self, from: data)
                        completion(nil, tokens)
                        return
                    } catch let error as NSError {
                        completion(error, nil)
                    }

                }
    }
}
