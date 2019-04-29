
import Foundation
import Big_Neon_Core
import Big_Neon_UI
import Alamofire

//public class ApiRepository {
//    
//    private init() {}
//    static let shared = ApiRepository()
//    
//    private let urlSession = URLSession.shared
//    private let baseURL = URL(string: "https://swapi.co/api/")!
//    
//    func getFilms(completion: @escaping(_ filmsDict: [[String: Any]]?, _ error: Error?) -> ()) {
//        let filmURL = baseURL.appendingPathComponent("films")
//        urlSession.dataTask(with: filmURL) { (data, response, error) in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            
//            guard let data = data else {
//                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
//                completion(nil, error)
//                return
//            }
//            
//            do {
//                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//                guard let jsonDictionary = jsonObject as? [String: Any],
//                    let result = jsonDictionary["results"] as? [[String: Any]] else {
//                        throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
//                }
//                completion(result, nil)
//            } catch {
//                completion(nil, error)
//            }
//            }.resume()
//    }
//    
//}


public class EventsApiRepository {
    
    private init() {}
    static let shared = EventsApiRepository()
    private let APIURL = APIService.getCheckins()
    
    
    func fetchEvents(completion: @escaping (_ fetchedEventsDict: [[String: Any]]?, _ error: Error?) -> ()) {
        
        let accessToken = BusinessService.shared.database.fetchAcessToken()
        
        AF.request(APIURL,
                   method: HTTPMethod.get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: [APIParameterKeys.authorization :"Bearer \(accessToken!)"])
            .validate(statusCode: 200..<300)
            .response { (response) in
                
                guard response.result.isSuccess else {
                    let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                    completion(nil, error)
                    return
                }
                
                guard let data = response.result.value else {
                    let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                    completion(nil, error)
                    return
                }
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    guard let jsonDictionary = jsonObject as? [String: Any],
                        let result = jsonDictionary["results"] as? [[String: Any]] else {
                            throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                    }
                    completion(result, nil)
                } catch {
                    completion(nil, error)
                }
        }
        
    }
    
}
