
import Foundation
import UserNotifications

extension NotificationService {
    
    public class func saveNotificationToken(withUserEmail userEmail: String) {
        /*
        guard let token: String = Messaging.messaging().fcmToken else {
            print("No Token Available")
            return
        }
        
        guard let doorPerson: User = User else {
            print("No user set")
            return
        }
        
        self.insert(notificationToken: token, userID: userEmail)
        
        */
    }
    
    /*
     * Refreshing the Notification Token
     */
    public class func refreshNotificationToken() {
        /*
        let instance = InstanceID.instanceID()
        
        instance.deleteID { (error) in
            print(error.debugDescription)
        }
        
        Messaging.messaging().shouldEstablishDirectChannel = true
        */
    }
    
    /*
    *  Firebase Channel Saving
    */
    
    /*
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        self.saveRegistrationToken(token: fcmToken)
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    */
    
    private func saveRegistrationToken(token: String) {
        /*
            self.insert(notificationToken: token, userID: doorPerson.id)
         */
    }
    
    
    /*
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    */
    
    func insert(notificationToken: String, userEmail: String) {
        
        
        /*
         *   Uses Firebase's Notification Service
        */
        
        /*
        docReference = Firestore.firestore()
            .collection(DatabaseKeys.Table.notificationTokens)
            .document(userID)
        docReference.addSnapshotListener { (snapShot, error) in
            
            guard let docSnapShot = snapShot, docSnapShot.exists else {
                self.insertNew(notificationToken: notificationToken, passenger: passenger)
                return
            }
            
            guard let tokens = docSnapShot.data()?.keys else {
                return
            }
            
            if tokens.contains(notificationToken) {
                return
            }
            
            self.insertNew(notificationToken: notificationToken, userID: UserID)
        }
        */
    }
        
    private func insertNew(notificationToken: String, userID: String) {
        /*
        docReference = Firestore.firestore()
            .collection(DatabaseKeys.Table.notificationTokens)
            .document(userID)
        docReference.setData([notificationToken: true])
        */
    }
    
}
