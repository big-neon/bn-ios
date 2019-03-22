

import Foundation
import Alamofire

extension DatabaseService {
    
    public func getRedeemTicket(forTicketID ticketID: String, completion: @escaping (ScanFeedback?, RedeemableTicket?) -> Void) {
        
        let APIURL = APIService.getRedeemableTicket(ticketID: ticketID)
        let accessToken = self.fetchAcessToken()

        print(APIURL)
        print(accessToken!)
        
        AF.request(APIURL,
                   method: HTTPMethod.get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
            .validate(statusCode: 200..<300)
            .response { (response) in
                
                guard response.result.isSuccess else {
                    switch response.result.error?.asAFError?.responseCode {
                    case 409:
                        completion(.alreadyRedeemed, nil)
                        return
                    case 404:
                        completion(.wrongEvent, nil)
                        return
                    default:
                        completion(.issueFound, nil)
                        return
                    }
                }
                
                guard let data = response.result.value else {
                    completion(.issueFound, nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let redeemKeyData = try decoder.decode(RedeemableTicket.self, from: data!)
                    completion(.validTicketID, redeemKeyData)
                    return
                } catch let error as NSError {
                    completion(.issueFound, nil)
                }
        }
    }
    
    
    public func redeemTicket(forTicketID ticketID: String, eventID: String, redeemKey: String, completion: @escaping (ScanFeedback, RedeemableTicket?) -> Void) {

        let apiURL = APIService.redeemTicket(eventID: eventID, ticketID: ticketID)
        let accessToken = self.fetchAcessToken()
        
        let parameters = ["ticket_id": ticketID,
                          "event_id": eventID,
                          "redeem_key": redeemKey]

        AF.request(apiURL,
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
            .validate(statusCode: 200..<300)
            .response { (response) in

                guard response.result.isSuccess else {
                    switch response.result.error?.asAFError?.responseCode {
                    case 409:
                        completion(.alreadyRedeemed, nil)
                        return
                    case 404:
                        completion(.wrongEvent, nil)
                        return
                    default:
                        completion(.issueFound, nil)
                        return
                    }
                }

                guard let data = response.result.value else {
                    completion(.issueFound, nil)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let ticket = try decoder.decode(RedeemableTicket.self, from: data!)
                    completion(.valid, ticket)
                    return
                } catch let error as NSError {
                    completion(.issueFound, nil)
                }
        }
    }
}
