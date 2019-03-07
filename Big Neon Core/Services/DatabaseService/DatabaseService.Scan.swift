

import Foundation
import Alamofire

extension DatabaseService {
    
    public func getRedeemKey(ticketID: String, completion: @escaping (Error?, RedeemedTicket?) -> Void) {
        
        
        let APIURL = APIService.redeem + "\(ticketID)/redeem"
        let accessToken = self.fetchAcessToken()

        AF.request(APIURL,
                   method: HTTPMethod.get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
            .validate(statusCode: 200..<300)
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
                    let redeemKeyData = try decoder.decode(RedeemedTicket.self, from: data!)
                    completion(nil, redeemKeyData)
                    return
                } catch let error as NSError {
                    completion(error, nil)
                }
        }
    }
    
    
    public func redeemTicket(ticketID: String, completion: @escaping (Error?) -> Void) {
        
        
        let APIURL = APIService.redeem + "\(ticketID)/redeem"
        let accessToken = self.fetchAcessToken()
        
        let parameters = ["ticket_id": ticketID]
        
        AF.request(APIURL,
                   method: HTTPMethod.get,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
            .validate(statusCode: 200..<300)
            .response { (response) in
                
                guard response.result.isSuccess else {
                    completion(response.result.error)
                    return
                }
                
                guard let data = response.result.value else {
                    completion(nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let checkins = try decoder.decode(Events.self, from: data!)
                    completion(nil)
                    return
                } catch let error as NSError {
                    completion(error)
                }
        }
    }
}
