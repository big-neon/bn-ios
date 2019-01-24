

import Foundation
import Alamofire
import JWTDecode

extension DatabaseService {
    
    public func getAccessToken(completion: @escaping (String?) -> Void) {
        
        // Fetch Access Token
        guard let accessToken = self.fetchAcessToken(), let refreshToken = self.fetchRefreshToken() else {
            completion(nil)
            return
        }
        
        //  Fetch the Expiration Time
        
        
        do {
            let jwt = try decode(jwt: accessToken)
            let expirationTime = jwt.expiresAt
            print(expirationTime)
        } catch {
            completion(nil)
        }
        
        //  Check if the token is expired
        
      
        
        //  If current time is > expiration time
        //  Fetch a new token
        
        //  Else return the current access token
        
        
        
        
        
        
//        let authParameters = ["email": email,
//                              "password": password]
//
//        let APIURL = APIService.users
//        let jsonData = try? JSONSerialization.data(withJSONObject: authParameters, options: .prettyPrinted)
//
//        let request = NSMutableURLRequest(url: NSURL(string: APIURL)! as URL,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 10.0)
//
//        request.setValue(APIParameterKeys.requestSetValue, forHTTPHeaderField: APIParameterKeys.headerField)
//        request.httpBody = jsonData
//
//        URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
//            if error != nil{
//                completion(error, nil)
//                return
//            }
//
//            guard let data = data else {
//                print("Error Fetching Data")
//                completion(nil, nil)
//                return
//            }
//
//            //            do {
//            //                let decoder = JSONDecoder()
//            //                let error = try decoder.decode(BasicError.self, from: data)
//            //                completion(BasicErrorImpl( title: "Error", description: error.error), nil)
//            //                return
//            //            }catch {
//            //
//            //            }
//
//            do {
//                let decoder = JSONDecoder()
//                let tokens = try decoder.decode(Tokens.self, from: data)
//                completion(nil, tokens)
//                return
//            } catch let error as NSError {
//                completion(error, nil)
//            }
//
//            }.resume()
    }
}
