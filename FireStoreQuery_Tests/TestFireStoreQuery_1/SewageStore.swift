//
//  ItemStore.swift
//  Homepwner
//
//  Created by Nick Hella on 10/24/20.
//

import UIKit

class SewageDataStore {
    
    var SewageDataItems = [SewageDataItem]()
//    var BurlingtonItems = [BurlingtonItem]()
//    var WinooskiItems = [WinooskiItem]()
//    var RutlandItems = [RutlandItem]()

    // @discardableResult means the caller can ignore the return object
    @discardableResult func createSewageDataItem(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) -> SewageDataItem {
                
        let newSewageDataItem = SewageDataItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater)
        
        SewageDataItems.append(newSewageDataItem)
        
        return newSewageDataItem
    }
    
//    // @discardableResult means the caller can ignore the return object
//    @discardableResult func createBurlingtonItem(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) -> BurlingtonItem {
//
//        let newBurlingtonItem = BurlingtonItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater)
//
//        BurlingtonItems.append(newBurlingtonItem)
//
//        return newBurlingtonItem
//    }
//
//    // @discardableResult means the caller can ignore the return object
//    @discardableResult func createWinooskiItem(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) -> WinooskiItem {
//
//        let newWinooskiItem = WinooskiItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater)
//
//        WinooskiItems.append(newWinooskiItem)
//
//        return newWinooskiItem
//    }
//
//    // @discardableResult means the caller can ignore the return object
//    @discardableResult func createRutlandItem(date: String, type: String, minGal: Int, maxGal: Int, location: String, receivingWater: String) -> RutlandItem {
//
//        let newRutlandItem = RutlandItem(date: date, type: type, minGal: minGal, maxGal: maxGal, location: location, receivingWater: receivingWater)
//
//        RutlandItems.append(newRutlandItem)
//
//        return newRutlandItem
//    }

    //Loading up initial lists
    init() {    
//        self.BurlingtonItems = []
//        self.WinooskiItems = []
//        self.RutlandItems = []
        self.SewageDataItems = []
    }
    
    func toString() {
        
//        if self.BurlingtonItems.count > 0 {
//            print("\n Burlington Items Are: ")
//            for item in self.BurlingtonItems {
//                item.toString()
//            }
//        }
//        
//        if self.RutlandItems.count > 0 {
//            print("\n Rutland Items Are: ")
//            for item in self.RutlandItems {
//                item.toString()
//            }
//        }
//        
//        if self.WinooskiItems.count > 0 {
//            print("\n Winooski Items Are: ")
//            for item in self.WinooskiItems {
//                item.toString()
//            }
//        }
        
        if self.SewageDataItems.count > 0 {
            print("\n SewageDataItems Items Are: ")
            for item in self.SewageDataItems {
                item.toString()
            }
        }
    }
}
