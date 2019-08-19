import Foundation
import Alamofire
import JWTDecode

extension DatabaseService {

    public func tokenIsExpired(completion: @escaping (Bool) -> Void) {
        guard let accessToken = self.fetchAcessToken() else {
            completion(false)
            return
        }

        do {
            let jwt = try decode(jwt: accessToken)
            let _ = jwt.expired
            let tokenExpiryDate = jwt.expiresAt

            if tokenExpiryDate! > Date.init(timeInterval: 60, since: Date()) {
                completion(true)
                return
            }
            
            completion(false)
            return
        } catch {
            completion(false)
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
