
import Foundation
import Alamofire

extension DatabaseService {
    
    public func fetchEvents(completion: @escaping (Error?, Events?) -> Void) {
        
        let APIURL = APIService.getEvents(eventID: nil)
        AF.request(APIURL,
                   method: HTTPMethod.get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: [:])
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
                    let events = try decoder.decode(Events.self, from: data)
                    completion(nil, events)
                    return
                } catch let error as NSError {
                    completion(error, nil)
                }
        }
    }
    
    public func fetchEvent(withID eventID: String, completion: @escaping (Error?, EventDetail?) -> Void) {
        
        let APIURL = APIService.getEvents(eventID: eventID)
        AF.request(APIURL,
                   method: HTTPMethod.get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: [:])
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
                    let event = try decoder.decode(EventDetail.self, from: data)
                    completion(nil, event)
                    return
                } catch let error as NSError {
                    print(error)
                    completion(error, nil)
                }
        }
    }

}
