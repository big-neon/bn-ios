
import Foundation

public class ScanDelaySeconds {
    
    class var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            } else {
                fatalError("Plist file not found")
            }
        }
    }
    
    class func fetchScanSeconds() -> Any {
        guard let secondsValue = infoDict["scan_delay_seconds"] else {
            return 10
        }
        return secondsValue
    }
}
