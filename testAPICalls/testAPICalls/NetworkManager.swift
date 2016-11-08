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
        
        let headers = [
            "Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiY29udGFjdElkIjoiMDAzbTAwMDAwMFd5WFpnQUFOIiwiZXhwIjoxNTEwMDc2NTQ1LCJpc3MiOiJsb2NhbGhvc3Q6ODA4MCJ9.GNZTfYJCwjQAY_1w-eHApQi9KnRATaIetp87XPOz0gE",
            "Content-Type":"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__",
            ]

        let configuration = URLSessionConfiguration.background(withIdentifier: "http://ehas2-dev-load-balancer-1527675904.us-east-1.elb.amazonaws.com/upload_s3")
        configuration.httpAdditionalHeaders = headers
        manager = Alamofire.SessionManager(configuration: configuration)
    }
}
