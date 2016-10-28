//
//  EpisodeCell.swift
//  Pod Player
//
//  Created by Nick Walter on 10/25/16.
//  Copyright © 2016 Zappy Code. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var descriptionWebView: WebView!
    @IBOutlet weak var pubDateLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
