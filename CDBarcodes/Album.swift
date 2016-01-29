//
//  Album.swift
//  CDBarcodes
//
//  Created by Matthew Maher on 1/29/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import Foundation

class Album {
    private var _album: String!
    private var _year: String!
    
    var album: String {
        return _album
    }
    
    var year: String {
        return _year
    }
    
    init(artistAlbum: String, albumYear: String) {
        self._album = artistAlbum
        self._year = albumYear
    }
}