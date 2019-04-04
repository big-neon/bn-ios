

import Foundation
import UIKit

extension GuestListView {
    
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = self.searchBar
        let scope = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope ?? "")
    }
    
    func searchBarIsEmpty() -> Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String) {
        //  TO BE ADDED LATER
        /*
         self.passengersViewModel.filteredPassengers = self.passengersViewModel.passengers.filter({( passenger : Passenger) -> Bool in
         return passenger.fullname.lowercased().contains(searchText.lowercased())
         })
         self.passengersTableView.reloadData()
         */
    }
    
    internal func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
}
