
import UIKit
import Sync
import Big_Neon_UI
import Big_Neon_Core

extension DoorPersonViewController {
    
    @objc func syncEventsData(withOrgID orgID: String?) {
        guard let orgID = orgID  else {
            self.doorPersonViemodel.eventCoreData = self.fetcher.fetchLocalEvents()
            self.orderEventsByDate()
            self.exploreCollectionView.reloadData()
            return
        }
        
        
        fetcher.syncCheckins(orgID: orgID) { result in
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
        
        /*
         Ordering the Date by least to greatests
         */
        self.doorPersonViemodel.eventCoreData.sort(by: {
            guard let firstEvent = $0.event_start,
                let firstDate = DateConfig.dateFromUTCString(stringDate: firstEvent),
                let secondEvent = $1.event_start,
                let endDate = DateConfig.dateFromUTCString(stringDate: secondEvent) else {
                return false
            }
            return firstDate < endDate
        })
   
        
        /*
         Get Events Occuring Today
         */
        self.doorPersonViemodel.todayEvents = self.doorPersonViemodel.eventCoreData.filter {
            guard let firstEvent = $0.event_start,
                let firstDate = DateConfig.dateFromUTCString(stringDate: firstEvent) else {
                return false
            }
            
            return DateConfig.dateIsWithinTwentyFourHours(ofDate: firstDate)
        }
        
        //  Get Future events
        self.doorPersonViemodel.upcomingEvents = self.doorPersonViemodel.eventCoreData.filter {
            guard let doorTimeEventEvent = $0.door_time,
                let firstDate = DateConfig.dateFromUTCString(stringDate: doorTimeEventEvent) else {
                return false
            }
            return DateConfig.dateIsInFutureDate(ofDate: firstDate)
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.exploreCollectionView.reloadData()
    }
    
    @objc func reloadEvents() {
        
        NetworkManager.shared.startNetworkReachabilityObserver { (isReachable) in
            if isReachable == true {
                self.doorPersonViemodel.fetchUser { (_) in
                    DispatchQueue.main.async {
                        guard let orgID = self.doorPersonViemodel.userOrg?.organizationScopes?.first?.key else {
                            return
                        }
                        
                        self.fetcher.syncCheckins(orgID: orgID) { result in
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
            } else {
                self.doorPersonViemodel.eventCoreData = self.fetcher.fetchLocalEvents()
                self.syncEventsData(withOrgID: nil)
                self.loadingView.stopAnimating()
                self.refresher.endRefreshing()
                self.exploreCollectionView.reloadData()
            }
        }
        
    }
}
