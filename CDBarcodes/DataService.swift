//
//  DataService.swift
//  CDBarcodes
//
//  Created by Matthew Maher on 1/29/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataService {
    
    static let dataService = DataService()
    
    private var _ALBUM = ""
    private var _YEAR = ""
    
    var ALBUM: String {
        return _ALBUM
    }
    
    var YEAR: String {
        return _YEAR
    }
    
    static func searchAPI(codeNumber: String) {
        
        print("AF Code: \(codeNumber)")
        
        Alamofire.request(.GET, "\(rhConstants.discogsAuthURL)\(codeNumber)&?barcode\(rhConstants.key)\(rhConstants.secret)")
            .responseJSON { response in
                
                var json = JSON(response.result.value!)
                
                let album = "\(json["results"][0]["title"])"
                let albumYear = "\(json["results"][0]["year"])"
//                let albumYear = "\(json["results"][0]["genre"][0])"
                
                self.ds._TITLE = title
                self.ds._ID_BAR = idBar
                self.ds._ID_CAT = idCat
                self.ds._GENRE = albumGenre
                
                print(title)
                print(idBar)
                print(idCat)
                print(albumGenre)
                
                print(self.ds._TITLE)
                print(self.ds._ID_BAR)
                print(self.ds._ID_CAT)
                print(self.ds._GENRE)
                
                NSNotificationCenter.defaultCenter().postNotificationName("ResultsReceived", object: nil)
                
        }
        
    }
    
    static func saveConfirmedRecord(newAlbum: String, newBarcode: String, newCategory: String, newGenre: String) {
        
        let capAlbumFirst = String(newAlbum.characters.prefix(1)).uppercaseString + String(newAlbum.characters.dropFirst())
        
        print(capAlbumFirst)
        
        let newRecord = PFObject(className:"Album")
        newRecord["albumName"] = capAlbumFirst
        newRecord["barIdentifier"] = newBarcode
        newRecord["catIdentifier"] = newCategory
        newRecord["genre"] = newGenre
        newRecord["albumOwner"] = PFUser.currentUser()
        
        newRecord.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            
            if (success) {
                NSNotificationCenter.defaultCenter().postNotificationName("ColloctionLoader", object: nil)
            } else {
                
            }
        }
    }
    
    static func countRecords() {
        
        let countQuery = PFQuery(className: "Album")
        countQuery.whereKey("albumOwner", equalTo: PFUser.currentUser()!)
        countQuery.countObjectsInBackgroundWithBlock { (count, error) -> Void in
            
            if error == nil
            {
                self.ds._ALBUM_COUNT = "\(count)"
                NSNotificationCenter.defaultCenter().postNotificationName("RecordCounter", object: nil)
            }
        }
    }
    
    static func exportRecords() {
        
        let exportQuery = PFQuery(className: "Album")
        exportQuery.whereKey("albumOwner", equalTo: PFUser.currentUser()!)
        exportQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                if objects != nil {
                    
                    var collectionCSVString = "Album,Genre,Barcode Number,Catalog Number\n"
                    
                    for var i = 0; i < objects!.count; i++ {
                        
                        let album = objects![i]["albumName"]
                        let genre = objects![i]["genre"]
                        let barcode = objects![i]["barIdentifier"]
                        let catNumber = objects![i]["catIdentifier"]
                        
                        collectionCSVString += "\(album),\(genre),\(barcode),\(catNumber)\n"
                        //                        self.ds._COLLECTION_STRING += "Album: \(album) -- Barcode Number: \(barcode) -- Catalog Number: \(catNumber)\n\n"
                        self.ds._COLLECTION_STRING += "\(album)\n\n"
                        
                    }
                    
                    print("CSV: \(collectionCSVString)")
                    print("STRING: \(self.ds._COLLECTION_STRING)")
                    
                    self.ds._COLLECTION_CSV = collectionCSVString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("RecordExporter", object: nil)
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }
    }
    
    static func clearCollectionString() {
        
        ds._COLLECTION_STRING = ""
        
    }
    
}
