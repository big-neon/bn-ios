
import Foundation
import UIKit

extension ExploreViewController {
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let headingCell: HeadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: HeadingCell.cellID, for: indexPath) as! HeadingCell
            headingCell.titleLabel.text = "Trips"
            return headingCell
        case 1:
            let homeTripsCell: HomeTripsCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTripsCell.cellID, for: indexPath) as! HomeTripsCell
            homeTripsCell.date = self.homeViewModel.sevenDayDates[0]
            homeTripsCell.passenger = self.homeViewModel.passenger
            homeTripsCell.dayStateView.noDriversLabel.isHidden = true
            homeTripsCell.dayStateView.drivers = self.homeViewModel.tomorrowsDrivers
            homeTripsCell.dayStateView.requests = self.homeViewModel.tomorrowRideRequests
            homeTripsCell.dayStateView.trip = self.homeViewModel.tomorrowTrip
            homeTripsCell.dayStateView.homeState = self.homeViewModel.tomorrowTripDayStatus
            if self.homeViewModel.tomorrowTripDayStatus == DayStatus.driverBooked {
                homeTripsCell.bookedTag.isHidden = false
                return homeTripsCell
            }
            homeTripsCell.bookedTag.isHidden = true
            return homeTripsCell
        case 2:
            let homeTripsCell: HomeTripsCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTripsCell.cellID, for: indexPath) as! HomeTripsCell
            homeTripsCell.date = self.homeViewModel.sevenDayDates[1]
            homeTripsCell.passenger = self.homeViewModel.passenger
            homeTripsCell.dayStateView.noDriversLabel.isHidden = true
            homeTripsCell.dayStateView.drivers = self.homeViewModel.day2Drivers
            homeTripsCell.dayStateView.requests = self.homeViewModel.day2RideRequests
            homeTripsCell.dayStateView.trip = self.homeViewModel.day2Trip
            homeTripsCell.dayStateView.homeState = self.homeViewModel.day2TripDayStatus
            if self.homeViewModel.day2TripDayStatus == DayStatus.driverBooked {
                homeTripsCell.bookedTag.isHidden = false
                return homeTripsCell
            }
            homeTripsCell.bookedTag.isHidden = true
            return homeTripsCell
        case 3:
            let homeTripsCell: HomeTripsCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTripsCell.cellID, for: indexPath) as! HomeTripsCell
            homeTripsCell.date = self.homeViewModel.sevenDayDates[2]
            homeTripsCell.passenger = self.homeViewModel.passenger
            homeTripsCell.dayStateView.noDriversLabel.isHidden = true
            homeTripsCell.dayStateView.drivers = self.homeViewModel.day3Drivers
            homeTripsCell.dayStateView.requests = self.homeViewModel.day3RideRequests
            homeTripsCell.dayStateView.trip = self.homeViewModel.day3Trip
            homeTripsCell.dayStateView.homeState = self.homeViewModel.day3TripDayStatus
            if self.homeViewModel.day3TripDayStatus == DayStatus.driverBooked {
                homeTripsCell.bookedTag.isHidden = false
                return homeTripsCell
            }
            homeTripsCell.bookedTag.isHidden = true
            return homeTripsCell
        case 4:
            let homeTripsCell: HomeTripsCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTripsCell.cellID, for: indexPath) as! HomeTripsCell
            homeTripsCell.date = self.homeViewModel.sevenDayDates[3]
            homeTripsCell.passenger = self.homeViewModel.passenger
            homeTripsCell.dayStateView.noDriversLabel.isHidden = true
            homeTripsCell.dayStateView.drivers = self.homeViewModel.day4Drivers
            homeTripsCell.dayStateView.requests = self.homeViewModel.day4RideRequests
            homeTripsCell.dayStateView.trip = self.homeViewModel.day4Trip
            homeTripsCell.dayStateView.homeState = self.homeViewModel.day4TripDayStatus
            if self.homeViewModel.day4TripDayStatus == DayStatus.driverBooked {
                homeTripsCell.bookedTag.isHidden = false
                return homeTripsCell
            }
            homeTripsCell.bookedTag.isHidden = true
            return homeTripsCell
        case 5:
            let homeTripsCell: HomeTripsCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTripsCell.cellID, for: indexPath) as! HomeTripsCell
            homeTripsCell.date = self.homeViewModel.sevenDayDates[4]
            homeTripsCell.passenger = self.homeViewModel.passenger
            homeTripsCell.dayStateView.noDriversLabel.isHidden = true
            homeTripsCell.dayStateView.drivers = self.homeViewModel.day5Drivers
            homeTripsCell.dayStateView.requests = self.homeViewModel.day5RideRequests
            homeTripsCell.dayStateView.trip = self.homeViewModel.day5Trip
            homeTripsCell.dayStateView.homeState = self.homeViewModel.day5TripDayStatus
            if self.homeViewModel.day5TripDayStatus == DayStatus.driverBooked {
                homeTripsCell.bookedTag.isHidden = false
                return homeTripsCell
            }
            homeTripsCell.bookedTag.isHidden = true
            return homeTripsCell
        default:
            let homeTripsCell: HomeTripsCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTripsCell.cellID, for: indexPath) as! HomeTripsCell
            homeTripsCell.date = self.homeViewModel.sevenDayDates[5]
            homeTripsCell.passenger = self.homeViewModel.passenger
            homeTripsCell.dayStateView.drivers = self.homeViewModel.day6Drivers
            homeTripsCell.dayStateView.requests = self.homeViewModel.day6RideRequests
            homeTripsCell.dayStateView.trip = self.homeViewModel.day6Trip
            homeTripsCell.dayStateView.homeState = self.homeViewModel.day6TripDayStatus
            if self.homeViewModel.day6TripDayStatus == DayStatus.driverBooked {
                homeTripsCell.bookedTag.isHidden = false
                return homeTripsCell
            }
            homeTripsCell.bookedTag.isHidden = true
            return homeTripsCell
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width, height: 40.0)
        default:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 290)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch indexPath.item {
        case 0:
            print("header label cell")
            return
        default:
            self.navigateToViewController(forIndex: indexPath.item - 1)
        }
    }
    
}
