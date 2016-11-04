//
//  ViewController.swift
//  testAPICalls
//
//  Created by Christopher Myers on 11/4/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    let todoEndpoint: String = "http://jsonplaceholder.typicode.com/todos/1"

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.urlReq()
        self.postReq()
        
        // Do any additional setup after loading the view, typically from a nib.
        

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
            todosUrlRequest.httpBody = jsonTodo as Data
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

}













