

import Foundation
import Alamofire

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
    case networkUnavailable = 101
    case wrongDataFormat = 102
}

extension DatabaseService {
    
    public func getRedeemTicket(forTicketID ticketID: String, completion: @escaping (ScanFeedback?, RedeemableTicket?) -> Void) {
        
        let APIURL = APIService.getRedeemableTicket(ticketID: ticketID)
        let accessToken = self.fetchAcessToken()

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
                    let redeemableTicket = try decoder.decode(RedeemableTicket.self, from: data!)
                    print(redeemableTicket)
                    completion(.validTicketID, redeemableTicket)
                    return
                } catch let error as NSError {
                    print(error)
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
                    print(error)
                    completion(.issueFound, nil)
                }
        }
    }
    
    public func fetchGuests(forEventID eventID: String, completion: @escaping (_ error: Error?, _ fetchedGuestsDict: [[String: Any]]?) -> Void) {
        
        let apiURL = APIService.fetchEvents(eventID: eventID)
        let accessToken = self.fetchAcessToken()
    
        AF.request(apiURL,
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
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    guard let jsonDictionary = jsonObject as? [String: Any],
                        let result = jsonDictionary["data"] as? [[String: Any]] else {
                            throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                    }
                    
                    completion(nil, result)
                    return
                } catch let error as NSError {
                    print(error)
                    completion(error, nil)
                }
        }
    }
}

