//
//  backgroundTimerRequest.swift
//  testAPICalls
//
//  Created by Christopher Myers on 11/8/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import Foundation



class BackgroundTimerRequest {
    
    var backgroundTaskIdentifier : UIBackgroundTaskIdentifier?
    
    init() {
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: { 
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        
    }
}
