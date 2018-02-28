//
//  ParseClient.swift
//  On The Map
//
//  Created by Polina Fiksson on 30/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation
import UIKit


class ParseClient: CommonClient {
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    func getStudentLocation(_ completionHandlerForStudentLocation: @escaping (_ result: [Student]?, _ error: NSError?) -> Void) {
        let methodParameters = [
            "limit": 100,"order":"-updatedAt"] as [String : Any]
       let method = "/StudentLocation"
        let headers = ["X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
                       "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"]
        
        let _ = taskForGETMethod(method, parameters: methodParameters as [String : AnyObject], headers: headers, API: "Parse") { (results, error) in
            if let error = error {
                completionHandlerForStudentLocation(nil, error)
            } else {
                
                if let results = results?["results"] as? [[String:AnyObject]]{
                    let students = Student.studentsFromResults(results)
                    completionHandlerForStudentLocation(students, nil)
                }else {
                    completionHandlerForStudentLocation(nil,NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
                }
            
           }
        }
}
    
    func postStudentLocation(_ completionHandlerForNewLocation: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let url = "https://parse.udacity.com/parse/classes/StudentLocation"
       
        let jsonBody = "{\"uniqueKey\": \"\(Student.sharedUser().accountKey)\", \"firstName\": \"\(Student.sharedUser().firstName)\", \"lastName\": \"\(Student.sharedUser().lastName)\",\"mapString\": \"\(Student.sharedUser().mapString)\", \"mediaURL\": \"\(Student.sharedUser().mediaURL)\",\"latitude\":\(Student.sharedUser().latitude), \"longitude\": \(Student.sharedUser().longitude)}"
        let headers = ["X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
                       "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
                       "Content-Type": "application/json"]

        /* 2. Make the request */
        let _ = taskForPOSTMethod(url, API: "Parse", jsonBody: jsonBody, headers: headers) { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForNewLocation(nil, error)
            } else {
                if let objectId = results?["objectId"] as? String {
                    completionHandlerForNewLocation(objectId, nil)
                } else {
                    completionHandlerForNewLocation(nil,NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
                }
            }
        }
    }
}

