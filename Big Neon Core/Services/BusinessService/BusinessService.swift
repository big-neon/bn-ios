

import Foundation

final public class BusinessService {
    
    public private(set) var database: DatabaseService               = DatabaseService()
    
    public class var shared: BusinessService {
        struct Static {
            static let instance: BusinessService = BusinessService()
        }
        return Static.instance
    }
}
