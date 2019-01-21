

import Foundation

extension DatabaseService {
    
    public func createUser(withEmail email: String, password: String, completion: @escaping (Error?, Tokens?) -> Void) {
        
        let authValues = ["email": email,
                          "password": password]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: authValues, options: .prettyPrinted)
        
        let APIURL = APIService.register
        let request = NSMutableURLRequest(url: NSURL(string: APIURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = APIParameterKeys.POST
        request.setValue(APIParameterKeys.requestSetValue, forHTTPHeaderField: APIParameterKeys.headerField)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error Fetching Data: \(error)")
                completion(error, nil)
                return
            }
            
            guard let data = data else {
                print("Error Fetching Data")
                completion(nil, nil)
                return
            }
        
            do {
                let decoder = JSONDecoder()
                let tokens = try decoder.decode(Tokens.self, from: data)
                completion(nil, tokens)
                return
            } catch {
                completion(nil, nil)
            }
            
            }.resume()
    }
    
    
    public func loginToAccount(withEmail email: String, password: String, completion: @escaping (Error?, Tokens?) -> Void) {
        
        let authValues = ["email": email,
                          "password": password]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: authValues, options: .prettyPrinted)
        
        let APIURL = APIService.login
        let request = NSMutableURLRequest(url: NSURL(string: APIURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = APIParameterKeys.POST
        request.setValue(APIParameterKeys.requestSetValue, forHTTPHeaderField: APIParameterKeys.headerField)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error Fetching Data: \(error)")
                completion(nil, nil)
                return
            }
            
            guard let data = data else {
                print("Error Fetching Data")
                completion(nil, nil)
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let tokens = try decoder.decode(Tokens.self, from: data)
                completion(nil, tokens)
                return
            } catch {
                completion(nil, nil)
            }
            
            }.resume()
    }
}
