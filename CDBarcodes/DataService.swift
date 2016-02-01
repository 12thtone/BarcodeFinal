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
        
        let discogsURL = "\(DISCOGS_AUTH_URL)\(codeNumber)&?barcode&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"
        
        print(discogsURL)
        
        Alamofire.request(.GET, discogsURL)
            .responseJSON { response in
                
                var json = JSON(response.result.value!)
                
                let albumArtistTitle = "\(json["results"][0]["title"])"
                let albumYear = "\(json["results"][0]["year"])"
                
                print(albumArtistTitle)
                print(albumYear)

                self.dataService._ALBUM = albumArtistTitle
                self.dataService._YEAR = albumYear
                
                NSNotificationCenter.defaultCenter().postNotificationName("AlbumNotification", object: nil)
        }
    }
}
