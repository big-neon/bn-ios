import Foundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core

/*
extension GuestListView {

    func searchBarIsEmpty() -> Bool {
        return self.searchBar.text?.isEmpty ?? true
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            self.isSearching = false
            self.guestTableView.reloadData()
            return
        }

        self.isSearching = true
        self.filteredSearchResults = ((self.guests?.filter({ (guestTicket: RedeemableTicket) -> Bool in
            
            guard let email = guestTicket.email else {
                return false
            }
            
            return guestTicket.firstName.lowercased().contains(searchText.lowercased()) || guestTicket.lastName.lowercased().contains(searchText.lowercased()) ||
                guestTicket.id.suffix(8).lowercased().contains(searchText.lowercased()) ||
                email.lowercased().contains(searchText.lowercased())
        }))!)

        self.guestTableView.reloadData()
    }

    internal func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearching = true
        self.searchBar.setShowsCancelButton(true, animated: true)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.searchBar.text = "";
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
        self.guestTableView.reloadData()
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }

}
 */
