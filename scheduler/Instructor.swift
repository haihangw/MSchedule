//
//  Instructor.swift
//  Scheduler
//
//  Created by Maxim Aleksa on 11/18/15.
//  Copyright © 2015 Maxim Aleksa. All rights reserved.
//

import Foundation

class Instructor: CustomStringConvertible, JSONInitializable {
    
    let instructorName: String
    let firstName: String
    let lastName: String
    let uniqname: String
    let role: String
    
    var description: String {
        get {
            return instructorName
        }
    }
    
    required init(json: NSDictionary) {
        
        self.instructorName = json["InstructorName"] as? String ?? "?"
        self.lastName = json["LastName"] as? String ?? "?"
        self.firstName = json["FirstName"] as? String ?? "?"
        self.role = json["InstructorRole"] as? String ?? "?"
        self.uniqname = (json["Uniqname"] as? String)?.lowercaseString ?? "?"
    }
}
