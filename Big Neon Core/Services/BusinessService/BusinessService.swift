

import Foundation

final public class BusinessService {
    
    public private(set) var database: DatabaseService = DatabaseService()
    public private(set) var notifications: NotificationService = NotificationService()
    
    public class var shared: BusinessService {
        struct Static {
            static let instance: BusinessService = BusinessService()
        }
        return Static.instance
    }
}
