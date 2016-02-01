//
//  AlbumDetailsViewController.swift
//  CDBarcodes
//
//  Created by Matthew Maher on 1/29/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit

class AlbumDetailsViewController: UIViewController {

    @IBOutlet weak var artistAlbumLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setLabels:", name:"AlbumNotification", object: nil)
        
        artistAlbumLabel.text = ""
        yearLabel.text = ""
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func setLabels(notification: NSNotification){
        
        let albumInfo = Album(artistAlbum: DataService.dataService.ALBUM, albumYear: DataService.dataService.YEAR)
        
        artistAlbumLabel.text = "\(albumInfo.album)"
        yearLabel.text = "\(albumInfo.year)"
    }
}
