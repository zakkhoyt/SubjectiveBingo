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
}

extension ZHGameKitHelper: GKMatchmakerViewControllerDelegate {
    func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFailWithError error: NSError) {
        
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFindMatch match: GKMatch) {
        
    }
    
}

extension ZHGameKitHelper: GKMatchDelegate {
    
}
