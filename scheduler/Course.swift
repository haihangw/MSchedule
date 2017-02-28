//
//  Course.swift
//  Scheduler
//
//  Created by Maxim Aleksa on 11/3/15.
//  Copyright © 2015 Maxim Aleksa. All rights reserved.
//

import Foundation

class Course: CustomStringConvertible, JSONInitializable {
    
    let name: String
    let catalogNumber: Int
    
    var description: String {
        get {
            return "\(catalogNumber)"
        }
    }
    
    required init(json: NSDictionary) {
        
        self.name = json["CourseDescr"] as? String ?? "?"
        self.catalogNumber = json["CatalogNumber"] as? Int ?? 0
    }
}