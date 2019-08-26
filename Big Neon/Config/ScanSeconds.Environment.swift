
import Foundation

public class BundleInfo {
    
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
    
    class func fetchVersionNumber() -> String {
        guard let versionNumber = infoDict["CFBundleShortVersionString"] as? String else {
            return ""
        }
        return versionNumber
    }
    
    class func fetchBuildNumber() -> String {
        guard let versionNumber = infoDict["CFBundleVersion"] as? String else {
            return ""
        }
        return versionNumber
    }
}
