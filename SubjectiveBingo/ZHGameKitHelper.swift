//
//  ZHGameKitHelper.swift
//  SubjectiveBingo
//
//  Created by Zakk Hoyt on 12/7/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

import UIKit
import GameKit

let ZHGameKitHelperLocalPlayerAuthenticated = "ZHGameKitHelperLocalPlayerAuthenticated"
let ZHGameKitHelperPresentAuthenticationViewController = "ZHGameKitHelperPresentAuthenticationViewController"

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
    
}

