//
//  Item.swift
//  Homepwner
//
//  Created by Nick Hella on 10/24/20.
//

import UIKit


// Template
class SewageDataItem: NSObject, NSCoding {
    
    var date: String
    var type: String!
    var minGal: Int!
    var maxGal: Int!
    let location: String!
    let receivingWater: String!
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(minGal, forKey: "minGal")
        aCoder.encode(maxGal, forKey: "maxGal")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(receivingWater, forKey: "receivingWater")
    }
    
    required init?(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObject(forKey: "date") as! String
        type = (aDecoder.decodeObject(forKey: "type") as! String)
        minGal = (aDecoder.decodeObject(forKey: "minGal") as! Int)
        maxGal = (aDecoder.decodeInteger(forKey: "maxGal") )
        location = (aDecoder.decodeInteger(forKey: "location") as! String)
        receivingWater = (aDecoder.decodeInteger(forKey: "receivingWater") as! String)
        
        super.init()
    }
    
    // Designated initilializer
    init(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) {
        
        self.date = date
        self.type = type
        self.minGal = minGal
        self.maxGal = maxGal
        self.location = location
        self.receivingWater = receivingWater
        
        super.init()
    }
    
    // Convenience initializer
//    convenience init(random: Bool = false) {
//        self.init(date: "02,30,21", type: "COG", minGal: 0, maxGal: 0, location: "jericho", receivingWater:"ocean")
//    } // end convenience init
    
    func toString(){
        print("\tLocation: \(self.location ?? "")")
        print("\t\tDate: \(self.date)")
        print("\t\tType: \(self.type ?? "")")
        print("\t\tMinGal: \(self.minGal ?? 0)")
        print("\t\tMaxGal: \(self.maxGal ?? 0)")
        print("\t\tReceivingWater: \(self.receivingWater ?? "")")
    }
}


//// Rutland item
//class RutlandItem: NSObject, NSCoding {
//
//    var date: String
//    var type: String!
//    var minGal: Int!
//    var maxGal: Int!
//    let location: String!
//    let receivingWater: String!
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(date, forKey: "date")
//        aCoder.encode(type, forKey: "type")
//        aCoder.encode(minGal, forKey: "minGal")
//        aCoder.encode(maxGal, forKey: "maxGal")
//        aCoder.encode(location, forKey: "location")
//        aCoder.encode(receivingWater, forKey: "receivingWater")
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        date = aDecoder.decodeObject(forKey: "date") as! String
//        type = (aDecoder.decodeObject(forKey: "type") as! String)
//        minGal = (aDecoder.decodeObject(forKey: "minGal") as! Int)
//        maxGal = (aDecoder.decodeInteger(forKey: "maxGal") )
//        location = (aDecoder.decodeInteger(forKey: "location") as! String)
//        receivingWater = (aDecoder.decodeInteger(forKey: "receivingWater") as! String)
//
//        super.init()
//    }
//
//    // Designated initilializer
//    init(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) {
//
//        self.date = date
//        self.type = type
//        self.minGal = minGal
//        self.maxGal = maxGal
//        self.location = location
//        self.receivingWater = receivingWater
//
//        super.init()
//
//    }
//
//    // Convenience initializer
////    convenience init(random: Bool = false) {
////        self.init(date: "02,30,21", type: "COG", minGal: 0, maxGal: 0, location: "jericho", receivingWater:"ocean")
////    } // end convenience init
//
//    func toString(){
//        print("\tLocation: \(self.location ?? "")")
//        print("\t\tDate: \(self.date)")
//        print("\t\tType: \(self.type ?? "")")
//        print("\t\tMinGal: \(self.minGal ?? 0)")
//        print("\t\tMaxGal: \(self.maxGal ?? 0)")
//        print("\t\tReceivingWater: \(self.receivingWater ?? "")")
//    }
//
//}
//
//
//// Burlington item
//class BurlingtonItem: NSObject, NSCoding {
//
//    var date: String
//    var type: String!
//    var minGal: Int!
//    var maxGal: Int!
//    let location: String!
//    let receivingWater: String!
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(date, forKey: "date")
//        aCoder.encode(type, forKey: "type")
//        aCoder.encode(minGal, forKey: "minGal")
//        aCoder.encode(maxGal, forKey: "maxGal")
//        aCoder.encode(location, forKey: "location")
//        aCoder.encode(receivingWater, forKey: "receivingWater")
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        date = aDecoder.decodeObject(forKey: "date") as! String
//        type = (aDecoder.decodeObject(forKey: "type") as! String)
//        minGal = (aDecoder.decodeObject(forKey: "minGal") as! Int)
//        maxGal = (aDecoder.decodeInteger(forKey: "maxGal") )
//        location = (aDecoder.decodeInteger(forKey: "location") as! String)
//        receivingWater = (aDecoder.decodeInteger(forKey: "receivingWater") as! String)
//
//        super.init()
//    }
//
//    // Designated initilializer
//    init(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) {
//
//        self.date = date
//        self.type = type
//        self.minGal = minGal
//        self.maxGal = maxGal
//        self.location = location
//        self.receivingWater = receivingWater
//
//        super.init()
//    }
//
//    // Convenience initializer
////    convenience init(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) {
////        self.init(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater:receivingWater)
////    } // end convenience init
//
//    func toString(){
//        print("\tLocation: \(self.location ?? "")")
//        print("\t\tDate: \(self.date)")
//        print("\t\tType: \(self.type ?? "")")
//        print("\t\tMinGal: \(self.minGal ?? 0)")
//        print("\t\tMaxGal: \(self.maxGal ?? 0)")
//        print("\t\tReceivingWater: \(self.receivingWater ?? "")")
//    }
//}
//
//// Winooski item
//class WinooskiItem: NSObject, NSCoding {
//
//    var date: String
//    var type: String!
//    var minGal: Int!
//    var maxGal: Int!
//    let location: String!
//    let receivingWater: String!
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(date, forKey: "date")
//        aCoder.encode(type, forKey: "type")
//        aCoder.encode(minGal, forKey: "minGal")
//        aCoder.encode(maxGal, forKey: "maxGal")
//        aCoder.encode(location, forKey: "location")
//        aCoder.encode(receivingWater, forKey: "receivingWater")
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        date = aDecoder.decodeObject(forKey: "date") as! String
//        type = (aDecoder.decodeObject(forKey: "type") as! String)
//        minGal = (aDecoder.decodeObject(forKey: "minGal") as! Int)
//        maxGal = (aDecoder.decodeInteger(forKey: "maxGal") )
//        location = (aDecoder.decodeInteger(forKey: "location") as! String)
//        receivingWater = (aDecoder.decodeInteger(forKey: "receivingWater") as! String)
//
//        super.init()
//    }
//
//    // Designated initilializer
//    init(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) {
//
//        self.date = date
//        self.type = type
//        self.minGal = minGal
//        self.maxGal = maxGal
//        self.location = location
//        self.receivingWater = receivingWater
//
//        super.init()
//    }
//
//    // Convenience initializer
////    convenience init(random: Bool = false) {
////        self.init(date: "02,30,21", type: "COG", minGal: 0, maxGal: 0, location: "jericho", receivingWater:"ocean")
////    } // end convenience init
//
//    func toString(){
//        print("\tLocation: \(self.location ?? "")")
//        print("\t\tDate: \(self.date)")
//        print("\t\tType: \(self.type ?? "")")
//        print("\t\tMinGal: \(self.minGal ?? 0)")
//        print("\t\tMaxGal: \(self.maxGal ?? 0)")
//        print("\t\tReceivingWater: \(self.receivingWater ?? "")")
//    }
//}
//
//
//// East creek item
//class EastCreekItem: NSObject, NSCoding {
//
//    var date: String
//    var type: String!
//    var minGal: Int!
//    var maxGal: Int!
//    let location: String!
//    let receivingWater: String!
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(date, forKey: "date")
//        aCoder.encode(type, forKey: "type")
//        aCoder.encode(minGal, forKey: "minGal")
//        aCoder.encode(maxGal, forKey: "maxGal")
//        aCoder.encode(location, forKey: "location")
//        aCoder.encode(receivingWater, forKey: "receivingWater")
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        date = aDecoder.decodeObject(forKey: "date") as! String
//        type = (aDecoder.decodeObject(forKey: "type") as! String)
//        minGal = (aDecoder.decodeObject(forKey: "minGal") as! Int)
//        maxGal = (aDecoder.decodeInteger(forKey: "maxGal") )
//        location = (aDecoder.decodeInteger(forKey: "location") as! String)
//        receivingWater = (aDecoder.decodeInteger(forKey: "receivingWater") as! String)
//
//        super.init()
//    }
//
//    // Designated initilializer
//    init(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) {
//
//        self.date = date
//        self.type = type
//        self.minGal = minGal
//        self.maxGal = maxGal
//        self.location = location
//        self.receivingWater = receivingWater
//
//        super.init()
//    }
//
//    // Convenience initializer
////    convenience init(random: Bool = false) {
////        self.init(date: "02,30,21", type: "COG", minGal: 0, maxGal: 0, location: "jericho", receivingWater:"ocean")
////    } // end convenience init
//
//    func toString(){
//        print("\tLocation: \(self.location ?? "")")
//        print("\t\tDate: \(self.date)")
//        print("\t\tType: \(self.type ?? "")")
//        print("\t\tMinGal: \(self.minGal ?? 0)")
//        print("\t\tMaxGal: \(self.maxGal ?? 0)")
//        print("\t\tReceivingWater: \(self.receivingWater ?? "")")
//    }
//}
