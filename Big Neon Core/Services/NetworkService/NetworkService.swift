
import Alamofire
import Foundation

public class NetworkManager {

    public static let shared = NetworkManager()

    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    public func startNetworkReachabilityObserver(completion: @escaping (Bool) -> Void) {
       
        self.reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                print("The network is not reachable")
                completion(false)
            case .unknown :
                print("It is unknown whether the network is reachable")
                completion(false)
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                completion(true)
            case .reachable(.cellular):
                print("The network is reachable over the Cellular connection")
                completion(true)
            }
        }
    }
   
}
