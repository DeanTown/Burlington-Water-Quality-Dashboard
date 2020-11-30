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
    let latitude: String!
    let longitude: String!
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(minGal, forKey: "minGal")
        aCoder.encode(maxGal, forKey: "maxGal")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(receivingWater, forKey: "receivingWater")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
    }

    required init?(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObject(forKey: "date") as! String
        type = (aDecoder.decodeObject(forKey: "type") as! String)
        minGal = (aDecoder.decodeObject(forKey: "minGal") as! Int)
        maxGal = (aDecoder.decodeInteger(forKey: "maxGal") )
        location = (aDecoder.decodeInteger(forKey: "location") as! String)
        receivingWater = (aDecoder.decodeInteger(forKey: "receivingWater") as! String)
        latitude = (aDecoder.decodeInteger(forKey: "latitude") as! String)
        longitude = (aDecoder.decodeInteger(forKey: "longitude") as! String)

        super.init()
    }
    
    // Designated initilializer
    init(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String, latitude: String, longitude: String) {
        
        self.date = date
        self.type = type
        self.minGal = minGal
        self.maxGal = maxGal
        self.location = location
        self.receivingWater = receivingWater
        self.latitude = latitude
        self.longitude = longitude
        
        super.init()
    }
    
    @discardableResult func toString() -> String {
        var tmp: String = "\tLocation: \(self.location ?? "")"
        tmp += "\t\tDate: \(self.date)"
        tmp += "\t\tType: \(self.type ?? "")"
        tmp += "\t\tMinGal: \(self.minGal ?? 0)"
        tmp += "\t\tMaxGal: \(self.maxGal ?? 0)"
        tmp += "\t\tReceivingWater: \(self.receivingWater ?? "")"
        tmp += "\t\tLatitude: \(self.latitude ?? "")"
        tmp += "\t\tLongitude: \(self.longitude ?? "")"
        print(tmp)
        return tmp
    }
    
    func getLocation() -> String {
        return self.location
    }
    func getDate() -> String  {
        return self.date
    }
    func getType() -> String  {
        return self.type
    }
    func getMinGal() -> Int  {
        return self.minGal
    }
    func getMaxGal() -> Int  {
        return self.maxGal
    }
    func getReceivingWater() -> String  {
        return self.receivingWater
    }
    func getLatitude() -> String  {
        return self.latitude
    }
    func getLongitude() -> String  {
        return self.longitude
    }
    
}
