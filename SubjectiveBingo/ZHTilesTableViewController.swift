//
//  ZHTilesTableViewController.swift
//  SubjectiveBingo
//
//  Created by Zakk Hoyt on 12/7/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

import UIKit
import GameKit

class ZHTilesTableViewController: UITableViewController {

    let tiles = ["Tile 1",
        "Tile 2",
        "Tile 3",
        "Tile 4",
        "Tile 5",
        "Tile 6",
        "Tile 7",
        "Tile 8",
        "Tile 9",
        "Tile 10",
        "Tile 11",
        "Tile 12",
        "Tile 13",
        "Tile 14",
        "Tile 15",
        "Tile 16",
        "Tile 17",
        "Tile 18",
        "Tile 19",
        "Tile 20",
        "Tile 21",
        "Tile 22",
        "Tile 23",
        "Tile 24",
        "Tile 25",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserverForName(ZHGameKitHelperLocalPlayerAuthenticated, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            ZHGameKitHelper.sharedInstance.findMatch(2, maxPlayers: 2, viewController: self, delegate: self)
        }
        
        
        ZHGameKitHelper.sharedInstance.authenticatePlayer()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel!.text = "\(indexPath.row + 1)"
        cell?.detailTextLabel!.text = tiles[indexPath.row]
        return cell!
    }
}

extension ZHTilesTableViewController: ZHGameKitHelperDelegate {
    func matchStarted() {
        print("match started")
    }
    func matchEnded() {
        print("match ended")
    }
    func match(match: GKMatch, data: NSData, playerID: String) {
        print("match received data")
    }

}
