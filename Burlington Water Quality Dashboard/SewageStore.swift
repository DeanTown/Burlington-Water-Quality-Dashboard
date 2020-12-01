//
//  Created by Nick Hella on 10/24/20.
//

import UIKit

class SewageDataStore {
    
    var SewageDataItems = [SewageDataItem]()

    // @discardableResult means the caller can ignore the return object
    @discardableResult func createSewageDataItem(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String, latitude: String, longitude: String) -> SewageDataItem {
                        
        let newSewageDataItem = SewageDataItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater, latitude: latitude, longitude: longitude)
        
        self.SewageDataItems.append(newSewageDataItem)
        
        return newSewageDataItem
    }
    
    //Loading up initial lists
    init() {
        self.SewageDataItems = []
    }
    
    @discardableResult func toString() -> String {
        var tmp: String = ""
        if self.SewageDataItems.count > 0 {
            print("\n SewageDataItems Items Are: ")
            for item in self.SewageDataItems {
                tmp = tmp + item.toString()
            }
        }
        return tmp
    }
    
    func clearStore() {
        self.SewageDataItems = []
    }
    
    func return_only_items_from_specified_receiving_water_loction(receivingWater: String) -> [SewageDataItem] {
        var tmp: [SewageDataItem] = []
        var count = 0
        while count < self.SewageDataItems.count {
            if self.SewageDataItems[count].getReceivingWater() == receivingWater {
                tmp.append(self.SewageDataItems[count])
            }
            count = count + 1
        }
        return tmp
    }
    
    @discardableResult func sortStore () -> [SewageDataItem] {
        self.SewageDataItems = self.SewageDataItems.sorted(by: { $0.date < $1.date })
        return self.SewageDataItems
    }
}
