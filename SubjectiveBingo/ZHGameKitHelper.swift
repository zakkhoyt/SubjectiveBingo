//
//  ZHGameKitHelper.swift
//  SubjectiveBingo
//
//  Created by Zakk Hoyt on 12/7/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//
//  See: http://www.raywenderlich.com/60998/game-center-tutorial-how-to-make-a-simple-multiplayer-game-with-sprite-kit-part-2



import UIKit
import GameKit

let ZHGameKitHelperLocalPlayerAuthenticated = "ZHGameKitHelperLocalPlayerAuthenticated"
let ZHGameKitHelperPresentAuthenticationViewController = "ZHGameKitHelperPresentAuthenticationViewController"


protocol ZHGameKitHelperDelegate {
    func matchStarted()
    func matchEnded()
    func match(match: GKMatch, data: NSData, playerID: String)
}


class ZHGameKitHelper: NSObject {

    static let sharedInstance = ZHGameKitHelper()
    
    var lastError: NSError? = nil {
        didSet{
            if let lastError = lastError {
                print("Error: " + lastError.localizedDescription)
            }
        }
    }
    
    var authenticationViewController: UIViewController? = nil {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(ZHGameKitHelperPresentAuthenticationViewController, object: nil)
        }
    }
    
    var enabledGameCenter: Bool = false
    var matchStarted: Bool = false
    var match: GKMatch? = nil
    var delegate: ZHGameKitHelperDelegate? = nil
    var playersDict = Dictionary<String, GKPlayer>()
    
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        if localPlayer.authenticated {
            NSNotificationCenter.defaultCenter().postNotificationName(ZHGameKitHelperLocalPlayerAuthenticated, object: nil)
            return
        }

        localPlayer.authenticateHandler =  ({ (viewController: UIViewController?, error: NSError?) -> Void in

            self.lastError = error

            if let viewController = viewController {
                self.authenticationViewController = viewController
            } else if localPlayer.authenticated {
                self.enabledGameCenter = true
                NSNotificationCenter.defaultCenter().postNotificationName(ZHGameKitHelperLocalPlayerAuthenticated, object: nil)
            } else {
                self.enabledGameCenter = false
            }
            
        })
    }
    
    
    func findMatch(minPlayers: Int, maxPlayers: Int, viewController: UIViewController, delegate: ZHGameKitHelperDelegate) {
        if !enabledGameCenter {
            return
        }
        
        self.matchStarted = false
        self.match = nil
        self.delegate = delegate
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        
        let mmvc = GKMatchmakerViewController(matchRequest: request)
        mmvc?.matchmakerDelegate = self
        viewController.presentViewController(mmvc!, animated: true, completion: nil)
    }


    func lookupPlayers() {
        print("Looking up \(match?.players.count) players...")
        GKPlayer.loadPlayersForIdentifiers((match?.playerIDs)!) { (players: [GKPlayer]?, error: NSError?) -> Void in
            if let error = error {
                print("Error retreiving plyer info: " + error.localizedDescription)
                self.matchStarted = false
                self.delegate?.matchEnded()
            } else {
                self.playersDict.removeAll()
                for player in players! {
                    print("Found player: " + player.playerID!)
                    self.playersDict[player.playerID!] = player
                }
                
                self.playersDict[GKLocalPlayer.localPlayer().playerID!] = GKLocalPlayer.localPlayer()
            }
        }
    }
    
}

extension ZHGameKitHelper: GKMatchmakerViewControllerDelegate {
    func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFailWithError error: NSError) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
        print("Error finding match: " + error.localizedDescription)
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFindMatch match: GKMatch) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
        self.match = match;
        match.delegate = self;
        if !matchStarted && match.expectedPlayerCount == 0 {
            print("Ready to start match!")
            lookupPlayers()
        }
    }
    
}

extension ZHGameKitHelper: GKMatchDelegate {
    
}
