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
    
    private(set) var ALBUM_FROM_DISCOGS = ""
    private(set) var YEAR_FROM_DISCOGS = ""
    
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

                self.dataService.ALBUM_FROM_DISCOGS = albumArtistTitle
                self.dataService.YEAR_FROM_DISCOGS = albumYear
                
                NSNotificationCenter.defaultCenter().postNotificationName("AlbumNotification", object: nil)
        }
    }
}
