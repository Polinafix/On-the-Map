//
//  CommonClient.swift
//  On The Map
//
//  Created by Polina Fiksson on 30/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation

// MARK: GET

class CommonClient: NSObject{
    // shared session
    var session = URLSession.shared
    
    func taskForGETMethod(_ method: String,parameters: [String:AnyObject],headers:[String:String],API:String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
    /* 1. Set the parameters */
    /* 2/3. Build the URL, Configure the request */
        let request:NSMutableURLRequest!
        let url:URL!
        if API == "Udacity"{
            request = NSMutableURLRequest(url: createURLFromParameters(parameters, scheme: Constants.Udacity.ApiScheme, host: Constants.Udacity.ApiHost, path: Constants.Udacity.ApiPath, withPathExtension: method))
        }else{
            request = NSMutableURLRequest(url: createURLFromParameters(parameters, scheme: Constants.Parse.ApiScheme, host: Constants.Parse.ApiHost, path: Constants.Parse.ApiPath, withPathExtension: method))
        }
        //get the headers
        for(key,value) in headers{
            request.addValue(value, forHTTPHeaderField: key)
        }
    
    /* 4. Make the request */
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
        }
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            sendError("There was an error with your request: \(error!)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            sendError("Your request returned a status code other than 2xx!")
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            sendError("No data was returned by the request!")
            return
        }
        
        /* 5/6. Parse the data and use the data (happens in completion handler) */
        if API == "Udacity"{
            let range = Range(uncheckedBounds: (5, data.count ))
            let newData = data.subdata(in: range)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
        }else if API == "Parse"{
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
    }
    
    /* 7. Start the request */
    task.resume()
    return task
}
    
    
    // MARK: POST
    func taskForPOSTMethod(_ url: String,API:String,jsonBody: String,headers:[String:String], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        let url = url
        let request = NSMutableURLRequest(url: URL(string:url)!)
        request.httpMethod = "POST"
        //headers
        for(key,value) in headers{
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }

            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error?.localizedDescription))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    sendError("Incorrect Credentials")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            if API == "Udacity" {
                let range = Range(uncheckedBounds: (5, data.count ))
                let newData = data.subdata(in: range)
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            } else if API == "Parse"{
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            }
        }
        /* 7. Start the request */
        task.resume()
        return task
    }
    
    //DELETE METHOD
    func taskForDELETEMethod(_ request: URLRequest, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range) /* subset response data! */
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        /* Start the request */
        task.resume()
        return task
    }
    
    // create a URL from parameters
    func createURLFromParameters(_ parameters: [String:Any],scheme:String,host:String,path:String, withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
}


