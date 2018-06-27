//
//  UdacityClient.swift
//  On The Map
//
//  Created by Polina Fiksson on 02/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation
import UIKit


class UdacityClient: CommonClient {
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    func loginWithFacebook(fbToken:String, completionHandlerForLoginWithFb: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let url = "https://www.udacity.com/api/session"
        let jsonBody = "{\"facebook_mobile\": {\"access_token\": \"" + fbToken + ";\"}}"
        print(jsonBody)
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let _ = taskForPOSTMethod(url, API: "Udacity", jsonBody: jsonBody, headers: headers) { (results, error) in
            /*Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLoginWithFb(false, error.localizedDescription)
            }else{
                if let account = results?["account"] as? [String:AnyObject]{
                    if let accountKey = account["key"] as? String {
                         print(accountKey)
                        Student.sharedUser().accountKey = accountKey
                        completionHandlerForLoginWithFb(true, nil)
                    }
                } else {
                    completionHandlerForLoginWithFb(false, "Invalid Credentials")
                }
            }
        }
    }
    
    //MARK: Method for login
    func login(username: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ error: String?) -> Void){
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body*/
        let url = "https://www.udacity.com/api/session"
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        let _ = taskForPOSTMethod(url, API: "Udacity", jsonBody: jsonBody, headers:headers) { (results, error) in
            /*Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLogin(false, error.localizedDescription)
            } else {
                if let account = results?["account"] as? [String:AnyObject]{
                    if let accountKey = account["key"] as? String {
                        Student.sharedUser().accountKey = accountKey
                        completionHandlerForLogin(true, nil)
                    }
                }else{
                    completionHandlerForLogin(false, "Invalid Credentials")
                }
            }
        }
    }
    
    //MARK: Method for getting current user's data
    func getUserData(_ completionHandlerForUserData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let headers = [String:String]()
        let method = "/users/\(Student.sharedUser().accountKey)"
        let methodParameters = [String:AnyObject]()
        
        /* Make the request */
        let _ = taskForGETMethod(method, parameters: methodParameters, headers: headers, API: "Udacity") { (results, error) in
            if error != nil {
                completionHandlerForUserData(false, "There was an error getting user data.")
            } else {
                if let user = results?["user"] as? [String:AnyObject] {
                    if let userFirstName = user["first_name"] as? String, let userLastName = user["last_name"] as? String {
                        Student.sharedUser().firstName = userFirstName
                        Student.sharedUser().lastName = userLastName
                        completionHandlerForUserData(true, nil)
                    }
                } else {
                    completionHandlerForUserData(false,"Could not get the user data.")
                }
            }
        }
    }
    //MARK: Method for logging out
    func logout(_ completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let urlString = "https://www.udacity.com/api/session"
        let request = NSMutableURLRequest(url:URL(string:urlString)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        /* Make the request */
        let _ = taskForDELETEMethod(request as URLRequest) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if error != nil {
                completionHandlerForLogout(false, "Logout Error")
            } else {
                if let session = results?["session"] as? NSDictionary {
                    if (session["expiration"] as? String) != nil{
                        completionHandlerForLogout(true, nil)
                    }
                } else {
                    completionHandlerForLogout(false,"Unable to logout")
                }
            }
        }
    }
}
    

