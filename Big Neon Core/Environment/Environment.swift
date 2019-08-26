
import Foundation

public enum PlistKey {
    case ServerURL
    case TimeoutInterval
    case ConnectionProtocol
    
    func value() -> String {
        switch self {
        case .ServerURL:
            return "server_url"
        case .ConnectionProtocol:
            return "protocol"
        default:
            print("Server URL no Found in environment")
            return ""
        }
    }
}

public struct Environment {
    
    fileprivate var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            }else {
                fatalError("Plist file not found")
            }
        }
    }
    public func configuration(_ key: PlistKey) -> String {
        switch key {
        case .ServerURL:
            return infoDict[PlistKey.ServerURL.value()] as! String
        case .ConnectionProtocol:
            return infoDict[PlistKey.ConnectionProtocol.value()] as! String
        default:
            print("Configuration Keys not found")
            return ""
        }
    }
}
