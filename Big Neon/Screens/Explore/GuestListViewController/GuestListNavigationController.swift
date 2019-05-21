
import Foundation
import PanModal

class GuestListNavigationController: UINavigationController, PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return (topViewController as? PanModalPresentable)?.panScrollable
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(600)
    }
    
}

