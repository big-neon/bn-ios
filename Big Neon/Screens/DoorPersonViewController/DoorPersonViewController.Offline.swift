
import UIKit
import Sync
import Big_Neon_UI
import Big_Neon_Core

extension DoorPersonViewController {
    
    @objc func syncEventsData() {
        fetcher.syncCheckins { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.doorPersonViemodel.eventCoreData = self.fetcher.fetchLocalEvents()
                    self.orderEventsByDate()
                    self.exploreCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func orderEventsByDate() {
        self.doorPersonViemodel.eventCoreData.sort(by: { DateConfig.dateFromUTCString(stringDate: $0.event_start!)! > DateConfig.dateFromUTCString(stringDate: $1.event_start!)!})
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.exploreCollectionView.reloadData()
    }
    
    @objc func reloadEvents() {
        fetcher.syncCheckins { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.loadingView.stopAnimating()
                    self.refresher.endRefreshing()
                    self.doorPersonViemodel.eventCoreData = self.fetcher.fetchLocalEvents()
                    self.orderEventsByDate()
                    self.exploreCollectionView.reloadData()
                case .failure(let error):
                    self.loadingView.stopAnimating()
                    self.refresher.endRefreshing()
                    if let err = error {
                        self.showFeedback(message: err.localizedDescription)
                    }
                    self.exploreCollectionView.reloadData()
                }
            }
        }
    }
}
