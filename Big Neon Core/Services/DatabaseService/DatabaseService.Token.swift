

import Foundation
import Alamofire
import JWTDecode

extension DatabaseService {
    
    public func tokenIsExpired(completion: @escaping (Bool) -> Void) {
        
        // Fetch Access Token
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
        
        print(refreshToken)
        
        let authParameters = ["refresh_token": refreshToken]
        let APIURL = APIService.updateUser
        
//        AF.request(APIURL,
//                   method: HTTPMethod.post,
//                   parameters: authParameters,
//                   encoding: JSONEncoding.default,
//                   headers: [APIParameterKeys.requestSetValue:APIParameterKeys.headerField])
//            .validate()
//            .response { (response) in
//
//                guard response.result.isSuccess else {
//                    print("Error while fetching tags: \(response.result.error)")
//                    completion(nil, nil)
//                    return
//                }
//
//                guard let data = response.result.value else {
//                    print("Invalid tag information received from the service")
//                    completion(nil, nil)
//                    return
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let tokens = try decoder.decode(Tokens.self, from: data!)
//                    completion(nil, tokens)
//                    return
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                    completion(error, nil)
//                }
//        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: authParameters, options: .prettyPrinted)
        let accessToken = self.fetchAcessToken()
        let request = NSMutableURLRequest(url: NSURL(string: APIURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)

        request.setValue(APIParameterKeys.requestSetValue, forHTTPHeaderField: APIParameterKeys.headerField)
        request.setValue(accessToken!, forHTTPHeaderField: APIParameterKeys.authorization)
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
                print(error.localizedDescription)
                completion(error, nil)
            }

            }.resume()
        
    }
}
