//
//  Created by Nick Hella on 10/24/20.
//

import UIKit

class SewageDataStore {
    
    // Our "cart" of sewage data items
    var SewageDataItems = [SewageDataItem]()
    
    // Initializing the Sewage Data Store
    init() {
        self.SewageDataItems = [] // Empty cart - but hey, you gotta start somewhere!
    }

    // @discardableResult means the caller can ignore the return object
    // Creating a sewage object to hold in our cart
    @discardableResult func createSewageDataItem(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String, latitude: String, longitude: String) -> SewageDataItem {
                        
        let newSewageDataItem = SewageDataItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater, latitude: latitude, longitude: longitude)
        
        self.SewageDataItems.append(newSewageDataItem)
        
        return newSewageDataItem
    }
    
    
    // Handy functions for the Sewage Data Store:
    
        // Print what's in our cart
        @discardableResult func toString() -> String {
            var tmp: String = "" // Creating a temp string to hold the toString output
            if self.SewageDataItems.count > 0 {
                print("\n SewageDataItems Items Are: ")
                for item in self.SewageDataItems {
                    tmp = tmp + item.toString() // building the temp string
                }
            }
            return tmp
        }
        
        // Clearing the cart of sewage items
        func clearStore() {
            self.SewageDataItems = []
        }
        
        // Return only the items in the store associated with a particular receiving water location
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
        
        // Sort the store by the dates associated with the items in our cart
        @discardableResult func sortStore () -> [SewageDataItem] {
            self.SewageDataItems = self.SewageDataItems.sorted(by: { $0.date < $1.date })
            return self.SewageDataItems
        }
    
} // end class
