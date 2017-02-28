//
//  Subject.swift
//  Scheduler
//
//  Created by Maxim Aleksa on 11/3/15.
//  Copyright © 2015 Maxim Aleksa. All rights reserved.
//

import Foundation

class Subject: CustomStringConvertible, JSONInitializable {
    
    let shortName: String
    let name: String
    let code: String
    
    var description: String {
        get {
            return shortName
        }
    }
    
    required init(json: NSDictionary) {
        
        self.shortName = (json["SubjectShortDescr"] as? String)?.uppercaseString ?? "?"
        self.name = json["SubjectDescr"] as? String ?? "?"
        self.code = (json["SubjectCode"] as? String)?.uppercaseString ?? "?"
    }
}
