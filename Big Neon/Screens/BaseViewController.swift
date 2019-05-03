import UIKit
import Big_Neon_UI

// MARK:  magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar
// MARK: internal is default access level - not need for explicit definition

class BaseViewController: UIViewController  {
    
    internal let doorPersonViemodel: DoorPersonViewModel = DoorPersonViewModel()
    // MARK: eventDetailViewModel should be let?
    internal var eventDetailViewModel: ExploreDetailViewModel = ExploreDetailViewModel()
    internal let ticketsViewModel: TicketsViewModel = TicketsViewModel()
    
    internal let loadingView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = UIActivityIndicatorView.Style.gray
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private func loadingAnimation() {
        self.view.addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingAnimation()
    }
    
}
