
import UIKit
import Foundation

public let WINDOW = UIScreen.main.bounds
public let iPhoneModel = (WINDOW.size.height == 568 ? 5 : (WINDOW.size.height == 480 ? 4 : (WINDOW.size.height == 667 ? 6 : (WINDOW.size.height == 736 ? 61 : 999))))

extension UIViewController {
    
    public func isiPhoneSE() -> Bool {
        switch UIScreen.main.nativeBounds.height {
        case 1136.0:
            return true
        default:
            return false
        }
    }
    
    public func isiPhone6() -> Bool {
        switch UIScreen.main.nativeBounds.height {
        case 1136.0:
            return true
        default:
            return false
        }
    }
    
    public func isiPhoneX() -> Bool {
        switch UIScreen.main.nativeBounds.height {
        case 2436:
            return true
        default:
            return false
        }
    }
    
    public func isiPhoneXr() -> Bool {
        switch UIScreen.main.nativeBounds.height {
        case 1792:
            return true
        default:
            return false
        }
    }
    
    public func isiPhoneXSMax() -> Bool {
        switch UIScreen.main.nativeBounds.height {
        case 2688:
            return true
        default:
            return false
        }
    }
    
    public func isiPhone8Plus() -> Bool {
        switch UIScreen.main.nativeBounds.height {
        case 2208:
            return true
        default:
            return false
        }
    }
    
}
