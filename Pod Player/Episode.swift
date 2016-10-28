//
//  Episode.swift
//  Pod Player
//
//  Created by Nick Walter on 10/25/16.
//  Copyright © 2016 Zappy Code. All rights reserved.
//

import Cocoa

class Episode {
    var title = ""
    var htmlDescription = ""
    var audioURL = ""
    var pubDate = Date()
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()
}
