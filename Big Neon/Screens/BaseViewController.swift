import UIKit
import Big_Neon_UI

// MARK:  magic numbers... consider using layout/config class/enum
// MARK: use abbreviation / syntax sugar

class BaseViewController: UIViewController  {
    
    let doorPersonViemodel: DoorPersonViewModel = DoorPersonViewModel()
    let eventDetailViewModel: ExploreDetailViewModel = ExploreDetailViewModel()
    let ticketsViewModel: TicketsViewModel = TicketsViewModel()
    
    let loadingView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = UIActivityIndicatorView.Style.gray
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private func loadingAnimation() {
        view.addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingAnimation()
    }
    
}
