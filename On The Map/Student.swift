//
//  Student.swift
//  On The Map
//
//  Created by Polina Fiksson on 03/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation

class Student{
    
    var objectId: String = ""
    var accountKey: String = ""//retrieved during login
    var fbToken:String = ""
    
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var latitude: Double?
    var longitude: Double?
    var mediaURL: String?
    var studentLocations = [Student]()

    init(dictionary: [String:AnyObject]) {
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        mediaURL = dictionary["mediaURL"] as? String
    }
    
    init() {}
    
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [Student] {
        var students = [Student]()
        // iterate through array of dictionaries, each Student is a dictionary
        for result in results {
            students.append(Student(dictionary: result))
        }
        return students
    }
    
    static func sharedUser() -> Student {
        struct Singleton {
            static var sharedUser = Student()
        }
        return Singleton.sharedUser
    }    
}



