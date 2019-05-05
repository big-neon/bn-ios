

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
            let expired = jwt.expired
            completion(expired)
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
                
//                do {
//                    let decoder = JSONDecoder()
//                    let userOrg = try decoder.decode(UserOrg.self, from: data!)
//                    let user = userOrg.user
//                    completion(nil, user)
//                    return
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                    completion(error, nil)
//                }
        }
        
        /*
        let jsonData = try? JSONSerialization.data(withJSONObject: authParameters, options: .prettyPrinted)
        let request = NSMutableURLRequest(url: NSURL(string: APIURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)

        request.setValue(APIParameterKeys.requestSetValue, forHTTPHeaderField: APIParameterKeys.headerField)
        request.httpMethod = APIParameterKeys.POST
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                completion(error, nil)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let tokens = try decoder.decode(Tokens.self, from: data)
                completion(nil, tokens)
                return
            } catch let error as NSError {
                completion(error, nil)
            }

            }.resume()
        */
    }
}
