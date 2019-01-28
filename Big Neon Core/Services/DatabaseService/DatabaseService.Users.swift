
import Foundation
import Alamofire

extension DatabaseService {

    public func insert(name: String, surname: String, completion: @escaping(Error?) -> Void) {
        
        let authParameters = ["first_name": name,
                              "last_name": surname]
        
        let APIURL = APIService.updateUser
        let jsonData = try? JSONSerialization.data(withJSONObject: authParameters, options: .prettyPrinted)
        
        let accessToken = self.fetchAcessToken()
        
        
        let request = NSMutableURLRequest(url: NSURL(string: APIURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.setValue(APIParameterKeys.requestSetValue, forHTTPHeaderField: APIParameterKeys.headerField)
        request.setValue(accessToken!, forHTTPHeaderField: APIParameterKeys.authorization)
        request.httpMethod = APIParameterKeys.PUT
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let error = try decoder.decode(BasicError.self, from: data)
                print("Error logging in: \(error.error)")
                completion(BasicErrorImpl( title: "Error", description: error.error))
                return
            }catch {
                
            }
            
            do {
                let decoder = JSONDecoder()
                let tokens = try decoder.decode(Tokens.self, from: data)
                completion(nil)
                return
            } catch let error as NSError {
                completion(error)
            }
            
            }.resume()
        
    }
    
    public func fetchUser(withAccessToken accessToken: String, completion: @escaping(Error?, User?) -> Void) {
        
        let APIURL = APIService.updateUser
        AF.request(APIURL,
            method: HTTPMethod.get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: [APIParameterKeys.authorization :"Bearer \(accessToken)"])
            .validate()
            .response { (response) in
                
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion(nil, nil)
                    return
                }
                
                guard let data = response.result.value else {
                    print("Invalid tag information received from the service")
                    completion(nil, nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userOrg = try decoder.decode(UserOrg.self, from: data!)
                    let user = userOrg.user
                    completion(nil, user)
                    return
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
        
        
        
        
        
        
        
//        let request = NSMutableURLRequest(url: NSURL(string: APIURL)! as URL,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 10.0)
//
//        request.setValue(APIParameterKeys.requestSetValue, forHTTPHeaderField: APIParameterKeys.headerField)
//        request.setValue(accessToken, forHTTPHeaderField: APIParameterKeys.authorization)
//        request.httpMethod = APIParameterKeys.GET
//
//        var sessionConfig = URLSessionConfiguration.default
//        var authValue: String? = "Bearer \(key)"
//        sessionConfig.httpAdditionalHeaders = ["Authorization": authValue ?? default value]
//        var session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
//
//        URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
//            if error != nil{
//                completion(error, nil)
//                return
//            }
//
//            guard let data = data else {
//                completion(nil, nil)
//                return
//            }
//
//            let httpResponse = response as! HTTPURLResponse
//            print(httpResponse.statusCode)
//
//            do {
//                let decoder = JSONDecoder()
//                let error = try decoder.decode(BasicError.self, from: data)
//                print("Error logging in: \(error.error)")
//                completion(BasicErrorImpl( title: "Error", description: error.error), nil)
//                return
//            }catch {
//
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let userOrg = try decoder.decode(UserOrg.self, from: data)
//                let user = userOrg.user
//                completion(nil, user)
//                return
//            } catch let error as NSError {
//                print(error.localizedDescription)
//                completion(error, nil)
//            }
//
//            }.resume()
        
        
    }
    
}
