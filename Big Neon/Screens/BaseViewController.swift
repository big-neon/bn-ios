import UIKit
import Big_Neon_UI

class BaseViewController: UIViewController  {
    
    let doorPersonViemodel: DoorPersonViewModel = DoorPersonViewModel()
    let eventDetailViewModel: ExploreDetailViewModel = ExploreDetailViewModel()
    let ticketsViewModel: TicketsViewModel = TicketsViewModel()
    let generator = UINotificationFeedbackGenerator()
    
    lazy var errorFeedback: FeedbackSystem = {
        let feedback = FeedbackSystem()
        return feedback
    }()
    
    lazy var fetcher: Fetcher = {
        let fetcher = Fetcher()
        return fetcher
    }()
    
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
    
    func showFeedback(message: String) {
        self.generator.notificationOccurred(.error)
        if let window = UIApplication.shared.keyWindow {
            self.errorFeedback.showFeedback(backgroundColor: UIColor.brandBlack,
                                            feedbackLabel: message,
                                            feedbackLabelColor: UIColor.white,
                                            durationOnScreen: 3.0,
                                            currentView: window,
                                            showsBackgroundGradient: true,
                                            isAboveTabBar: false)
        }
    }
    
    func handleShowHome() {
        let tabBarVC = UINavigationController(rootViewController: DoorPersonViewController(fetcher: self.fetcher))
        tabBarVC.modalTransitionStyle = .flipHorizontal
        self.present(tabBarVC, animated: false, completion: nil)
    }
    
    @objc func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
