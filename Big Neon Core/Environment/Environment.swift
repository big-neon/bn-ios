
import Foundation

public enum PlistKey {
    case ServerURL
    case TimeoutInterval
    case ConnectionProtocol
    case testEventID
    case testAuthEmail
    case testAuthenticationPassword
    
    public func value() -> String {
        switch self {
        case .ServerURL:
            return "server_url"
        case .ConnectionProtocol:
            return "protocol"
        case .testEventID:
            return "testEventID"
        case .testAuthEmail:
            return "testAuthEmail"
        case .testAuthenticationPassword:
            return "testAuthenticationPassword"
        default:
            print("Server URL no Found in environment")
            return ""
        }
    }
}

public struct Environment {
    
    public var infoDict: [String: Any]  {
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
        case .testEventID:
            return infoDict[PlistKey.testEventID.value()] as! String
        case .testAuthEmail:
            return infoDict[PlistKey.testAuthEmail.value()] as! String
        case .testAuthenticationPassword:
            return infoDict[PlistKey.testAuthenticationPassword.value()] as! String
        default:
            print("Configuration Keys not found")
            return ""
        }
    }
}
