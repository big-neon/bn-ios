
import Foundation

extension Double {
    
    func round(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    public var dollarString:String {
        return String(format: "$%.2f", self)
    }
}

extension Int {
    
    public var dollarString:String
    {
        if self/100 == 0 {
            return "FREE"
        }
        return "$\(self/100)"
    }
    
}
