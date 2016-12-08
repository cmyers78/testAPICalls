//
//  NetworkManager.swift
//  testAPICalls
//
//  Created by Christopher Myers on 11/8/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    var manager : SessionManager?
    
    init() {
        
        
//        let headers = [
//            // make sure to have userID token
//            "Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiY29udGFjdElkIjoiMDAzbTAwMDAwMFd5WFpnQUFOIiwiZXhwIjoxNTExOTc2NjczLCJpc3MiOiJsb2NhbGhvc3Q6ODA4MCJ9.BLQFBanzFNWH0yhSKRjXORV3dE14bP9asoKATdDzV58",
//            "Content-Type":"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__",
//            ]
//
//        let configuration = URLSessionConfiguration.background(withIdentifier: "http://healthyagingmobileapp-dev.emory.edu/upload_s3")
//        configuration.httpAdditionalHeaders = headers
        
        let serverTrustPolicy : [String : ServerTrustPolicy] = [
            "healthyagingmobile-dev.emory.edu" : ServerTrustPolicy.disableEvaluation
        ]

        manager = Alamofire.SessionManager(serverTrustPolicyManager : ServerTrustPolicyManager(policies: serverTrustPolicy))
        
        let cert = PKCSImport.init(mainBundleResource: "devclient", resourceType: "p12", password: "")
        
        manager?.delegate.sessionDidReceiveChallenge = { session, challenge in
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
                return (URLSession.AuthChallengeDisposition.useCredential, cert.urlCredential())
            }
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
            }
            return (URLSession.AuthChallengeDisposition.performDefaultHandling, Optional.none)
        }

        
    }
}
