//
//  School.swift
//  Scheduler
//
//  Created by Maxim Aleksa on 11/2/15.
//  Copyright © 2015 Maxim Aleksa. All rights reserved.
//

import Foundation

class School: CustomStringConvertible, JSONInitializable {
    
    let shortName: String
    let name: String
    let code: String
    
    var description: String {
        get {
            return shortName
        }
    }
    
    required init(json: NSDictionary) {
        
        self.shortName = json["SchoolShortDescr"] as? String ?? "?"
        self.name = json["SchoolDescr"] as? String ?? "?"
        self.code = json["SchoolCode"] as? String ?? "?"
    }
}