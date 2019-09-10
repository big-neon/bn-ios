


import Foundation
import Alamofire

extension DatabaseService {
    
    public func fetchCheckins(completion: @escaping (Error?, Events?) -> Void) {
        
        
        let APIURL = APIService.getCheckins()
        let accessToken = TokenService.shared.fetchAcessToken()
        
        AF.request(APIURL,
                   method: HTTPMethod.get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
            .validate(statusCode: 200..<300)
            .response { (response) in
                
                if let err = response.error {
                    completion(err, nil)
                    return
                }
                
                guard let data = response.data else {
                    completion(nil, nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let checkins = try decoder.decode(Events.self, from: data)
                    completion(nil, checkins)
                    return
                } catch let error as NSError {
                    print(error)
                    completion(error, nil)
                }
        }
    }
}
