
import UIKit
import Sync
import Big_Neon_UI
import Big_Neon_Core

extension GuestListViewController {
    
    /*
    @objc func syncGuestsData() {
        guestsFetcher?.syncCheckins { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.doorPersonViemodel.eventCoreData = self.fetcher.fetchLocalEvents()
                    self.guestTableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.guestTableView.reloadData()
    }
    
    @objc func reloadEvents() {
        self.doorPersonViemodel.configureAccessToken { [weak self] (completed) in
            DispatchQueue.main.async {
                self?.loadingView.stopAnimating()
                self?.refresher.endRefreshing()
                
                if completed == false {
                    self?.exploreCollectionView.reloadData()
                    return
                }
                self?.exploreCollectionView.reloadData()
                return
            }
        }
    }
 
    */
}
