import UIKit
import BigNeonUI

class BaseViewController: UIViewController  {
    
    internal let exploreViewModel: ExploreViewModel = ExploreViewModel()
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
