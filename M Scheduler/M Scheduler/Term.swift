//
//  Term.swift
//  Scheduler
//
//  Created by Maxim Aleksa on 11/3/15.
//  Copyright © 2015 Maxim Aleksa. All rights reserved.
//

import Foundation

class Term: CustomStringConvertible {
    let code: Int
    let year: Int
    let semester: String
    
    var description: String {
        get {
            return "\(semester) \(year)"
        }
    }
    
    init(code: Int, year: Int, semester: String) {
        
        self.code = code
        self.year = year
        self.semester = semester
    }
}