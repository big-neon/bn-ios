
import Foundation

public class ScanDelaySeconds {
    
    class var infoDict: [String: Any]  {
        get {
            guard let dict = Bundle.main.infoDictionary else {
                fatalError("Plist file not found")
            }
            return dict
        }
    }
    
    class func fetchScanSeconds() -> Int {
        guard let secondsValue = infoDict["scan_delay_seconds"] as? Int else {
            return 10
        }
        return secondsValue
    }
}
