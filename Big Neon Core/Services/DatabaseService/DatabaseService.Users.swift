
import Foundation

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
    
    public func fetchUser(withAccessToken token: String, completion: @escaping(Error?, User?) -> Void) {
        
        let APIURL = APIService.updateUser
        let accessToken = self.fetchAcessToken()
        let request = NSMutableURLRequest(url: NSURL(string: APIURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.setValue(APIParameterKeys.requestSetValue, forHTTPHeaderField: APIParameterKeys.headerField)
        request.setValue(accessToken!, forHTTPHeaderField: APIParameterKeys.authorization)
        request.httpMethod = APIParameterKeys.GET
        
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
                let error = try decoder.decode(BasicError.self, from: data)
                print("Error logging in: \(error.error)")
                completion(BasicErrorImpl( title: "Error", description: error.error), nil)
                return
            }catch {
                
            }
            
            do {
                let decoder = JSONDecoder()
                let userOrg = try decoder.decode(UserOrg.self, from: data)
                let user = userOrg.user
                completion(nil, user)
                return
            } catch let error as NSError {
                completion(error, nil)
            }
            
            }.resume()
        
        
    }
    
}
