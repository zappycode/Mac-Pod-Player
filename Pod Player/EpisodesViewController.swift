//
//  EpisodesViewController.swift
//  Pod Player
//
//  Created by Nick Walter on 10/25/16.
//  Copyright © 2016 Zappy Code. All rights reserved.
//

import Cocoa
import AVFoundation

class EpisodesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var deleteButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var pausePlayButton: NSButton!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!
    
    var podcast : Podcast? = nil
    var podcastsVC : PodcastsViewController? = nil
    var episodes : [Episode] = []
    var player : AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        updateView()
    }
    
    func updateView() {
        if podcast?.title != nil {
            titleLabel.stringValue = podcast!.title!
        } else {
            titleLabel.stringValue = ""
        }
        
        if podcast?.imageURL != nil {
            let image = NSImage(byReferencing: URL(string: podcast!.imageURL!)!)
            imageView.image = image
        } else {
            imageView.image = nil
        }
        
        if podcast != nil {
            tableView.isHidden = false
            deleteButton.isHidden = false
        } else {
            tableView.isHidden = true
            deleteButton.isHidden = true
        }
        
        pausePlayButton.isHidden = true
        
        getEpisodes()
        
    }
    
    func getEpisodes() {
        if podcast?.rssURL != nil {
            
            if let url = URL(string: podcast!.rssURL!) {
                
                URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
                    
                    if error != nil {
                        print(error)
                        
                    } else {
                        if data != nil {
                            let parser = Parser()
                            self.episodes = parser.getEpisodes(data: data!)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    }.resume()
            }
        }
    }
    
    @IBAction func deleteClicked(_ sender: AnyObject) {
        
        if podcast != nil {
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.managedObjectContext {
                context.delete(podcast!)
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                
                podcastsVC?.getPodcasts()
                
                podcast = nil
                updateView()
            }
        }
        
    }
    
    @IBAction func pausePlayClicked(_ sender: AnyObject) {
        if pausePlayButton.title == "Pause" {
            player?.pause()
            pausePlayButton.title = "Play"
        } else {
            player?.play()
            pausePlayButton.title = "Pause"
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let episode = episodes[row]
        let cell = tableView.make(withIdentifier: "episodeCell", owner: self) as? EpisodeCell
        cell?.titleLabel.stringValue = episode.title
        cell?.descriptionWebView.mainFrame.loadHTMLString(episode.htmlDescription, baseURL: nil)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        cell?.pubDateLabel.stringValue = dateformatter.string(from: episode.pubDate)
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let episode = episodes[tableView.selectedRow]
            if let url = URL(string: episode.audioURL) {
                player?.pause()
                player = nil
    
                player = AVPlayer(url: url)
                player?.play()
            }
            
            pausePlayButton.isHidden = false
            pausePlayButton.title = "Pause"
        }
    }
    
}
