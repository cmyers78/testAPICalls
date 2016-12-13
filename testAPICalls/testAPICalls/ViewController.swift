//
//  ViewController.swift
//  testAPICalls
//
//  Created by Christopher Myers on 11/4/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let sessionManager = NetworkManager()
    let flankerManager = NetworkManager()
    
    let headers = [
        // make sure to have userID token
        "Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiY29udGFjdElkIjoiMDAzbTAwMDAwMFd5WFpnQUFOIiwiZXhwIjoxNTExOTc2NjczLCJpc3MiOiJsb2NhbGhvc3Q6ODA4MCJ9.BLQFBanzFNWH0yhSKRjXORV3dE14bP9asoKATdDzV58",
        "Content-Type":"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__",
        ]
    
    
    let todoEndpoint: String = "http://jsonplaceholder.typicode.com/todos/1"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testString = "This is a test.  this is only a test."
        
        self.writeDataToFile(content: testString)
        let filePath = self.getDocumentsDirectory()
        print(filePath)
        let completedURL = filePath.appendingPathComponent("Testing_file_upload.txt")
        
        self.sendDataReq(fileURL: completedURL)
        self.sendContactReq(userID: "testing_billygates", dateTime: "Friday, Dec 9 2016")
        
        
    }
    
   
//    func sendRequestRequest() {
//        /**
//         Request
//         POST http://ehas2-dev-load-balancer-1527675904.us-east-1.elb.amazonaws.com/upload_s3
//         */
//        
//        // Add Headers
//        let headers = [
//            "Authorization":"Bearer", //USERID TOKEN GOES HERE
//            "Content-Type":"application/x-www-form-urlencoded; charset=utf-8",
//            ]
//        
//        // Form URL-Encoded Body
//        let body = [
//            "folder":"Flanker_Data",
//            "upload":"STRING NAME FROM FILE IN DOCUMENTS DIRECTORY",
//            ]
//        
//        // Fetch Request
//        
//       // Alamofire.request(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
//        
//        Alamofire.request("http://ehas2-dev-load-balancer-1527675904.us-east-1.elb.amazonaws.com/upload_s3", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
//            .validate(statusCode: 200..<300)
//            .responseJSON { response in
//                if (response.result.error == nil) {
//                    debugPrint("HTTP Response Body: \(response.data)")
//                }
//                else {
//                    debugPrint("HTTP Request failed: \(response.result.error)")
//                }
//        }
//    }
    
    func sendDataReq(fileURL : URL) {
        
        sessionManager.manager?.upload(multipartFormData: { multipartFormData in multipartFormData.append("Flanker_Data".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "folder")
            multipartFormData.append(fileURL, withName: "upload"/*, fileName: "results.txt", mimeType: "txt/csv"*/)}, to: "https://healthyagingmobileapp-dev.emory.edu/upload_s3", headers: self.headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in debugPrint(response) }
                    
                case .failure(let encodingError): print(encodingError)
                }
        })
    }
    
    func sendContactReq(userID : String, dateTime : String) {
        
        flankerManager.manager?.upload(multipartFormData: { multipartFormData in multipartFormData.append("\(dateTime)".data(using: .utf8, allowLossyConversion: false)!, withName: "date_time")
            multipartFormData.append("\(userID)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"s_path")
        }, usingThreshold: UInt64.init(), to: "https://healthyagingmobileapp-dev.emory.edu/contactgame/flanker", method: .post, headers: self.headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _): upload.responseJSON { response in debugPrint(response) }
                
            case .failure(let encodingError): print(encodingError)
            }
        })
    }

    func aFireGETReq() {
        Alamofire.request(todoEndpoint).responseJSON(completionHandler: { response in
            guard response.result.error == nil else {
                print("Error calling GET to /todos/1")
                print(response.result.error!)
                return
            }
            
            if let value = response.result.value {
                let todo = JSON(value)
                
                print("The todo is: " + todo.description)
                if let title = todo["title"].string {
                    
                    print("The title is: " + title)
                } else {
                    print("error parsing /todos/1")
                }
            }
            
            
        })
    }
    
    func aFirePOSTExample() {
        let parameters: Parameters = [
            "foo": [1,2,3],
            "bar": [
                "baz": "qux"
            ]
        ]
        
        // Both calls are equivalent
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: { response in
            
            guard response.result.error == nil else {
                print("some stuff")
                return
            }
            
            if let value = response.result.value {
                print(value)
                let todo = JSON(value)
                print("The todo is: " + todo.description)
            }
            
        })
    }
    
    func aFirePOSTReq() {
        let newTodo : Parameters = ["title": "Frist todo", "body": "I iz fisrt", "userId": 1, "completed": false]
        
        Alamofire.request("https://httpbin.org/post",method: .post, parameters: newTodo, encoding: JSONEncoding.default).responseJSON(completionHandler: { response in
            
            guard response.result.error == nil else {
                print("Error calling post to /todos/1")
                print(response.result.error ?? "Hey dumbass, this broke")
                return
            }
            
            if let value = response.result.value {
                print(value)
                let todo = JSON(value)
                print("The to do is:" + todo.description)
            }
            
        })
        
    }
    

    
    // MARK : Quick API GET call without authentication
    func urlReq() {
        // Set up URL Request
        let todoEndpoint: String = "http://jsonplaceholder.typicode.com/todos/1"
        
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        // Create a URLSession
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // do stuff with reponse, data, & error here
            
            // 1. Make sure we got data and no error
            // 2. Try to transform the data in JSON (since that's the format returned by the API)
            // 3. Access the todo object in the JSON and print out the title
            
            // error handling
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error ?? "Error")
                return
            }
            
            print("Response: ")
            print(response as Any)
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            // Step 1: grabs the entire JSON file and serializes it into JSON object
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                print("The todo is: " + todo.description)
                
                // Step 2: parses the title out of the JSON object
                guard let todoTitle = todo["title"] as? String else {
                    print("Could nto get todo title form JSON")
                    return
                }
                print ("The title is: " + todoTitle)
                
            } catch {
                print("error trying to convert data to json")
            }
            
            
        })
        
        task.resume()
    }
    
    // MARK : QUICK API POST Request without authentication
    
    func postReq() {
        
        let todosEndpoint: String = "http://jsonplaceholder.typicode.com/todos"
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        // Adding httpMethod instead of default: GET
        todosUrlRequest.httpMethod = "POST"
        
        // Creating new Dictionary to upload to server
        let newTodo = ["title": "Frist todo", "body": "I iz fisrt", "userId": 1, "completed": false] as [String : Any]
        // Converts to NSData
        let jsonTodo: Data
        // Converts Data to JSONObject
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            // adds the jsonObject to the httpBody
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        // Sets configuration and creates URL session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // creates data task in the session and uses the urlRequest for the upload website and sends the JSONObject to the server
        let task = session.dataTask(with: todosUrlRequest) {
            // Receives JSON data back from server...or error if issue
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error ?? "ERRROR")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: AnyObject] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The todo is: " + receivedTodo.description)
                
                guard let todoID = receivedTodo["id"] as? Int else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                print("The ID is: \(todoID)")
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print("here comes the directory name:")
        print()
        print()
        
        return documentsDirectory
    }

    
    func writeDataToFile(content: String) {
        let data = content
        let filePath = getDocumentsDirectory()
        
        let completedFileName = "Testing_file_upload.txt"
        
        
        let fileURL = filePath.appendingPathComponent(completedFileName)
        
        do {
            try data.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            print("write successful")
            
        } catch {
            print("There was an error writing the file")
        }
    }
    
    
    
}













