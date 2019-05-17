
import Foundation
import PanModal

class GuestListNavigationController: UINavigationController, PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return (topViewController as? PanModalPresentable)?.panScrollable
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
    
    var shortFormHeight: PanModalHeight {
        return longFormHeight
    }
}

