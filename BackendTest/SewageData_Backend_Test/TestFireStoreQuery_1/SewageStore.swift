//
//  ItemStore.swift
//  Homepwner
//
//  Created by Nick Hella on 10/24/20.
//

import UIKit

class SewageDataStore {
    
    var SewageDataItems = [SewageDataItem]()

    // @discardableResult means the caller can ignore the return object
    @discardableResult func createSewageDataItem(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) -> SewageDataItem {
        
        //print("\ncreateSewageDataItem creating sweage item!")
                
        let newSewageDataItem = SewageDataItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater)
        
        SewageDataItems.append(newSewageDataItem)
        
        return newSewageDataItem
    }
    
    //Loading up initial lists
    init() {
        self.SewageDataItems = []
    }
    
    func toString() {
        if self.SewageDataItems.count > 0 {
            print("\n SewageDataItems Items Are: ")
            for item in self.SewageDataItems {
                item.toString()
            }
        }
    }
    
}
