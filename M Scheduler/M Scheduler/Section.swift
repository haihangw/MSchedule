//
//  Section.swift
//  Scheduler
//
//  Created by Maxim Aleksa on 11/3/15.
//  Copyright © 2015 Maxim Aleksa. All rights reserved.
//

import Foundation

class Section: CustomStringConvertible {
    
    enum EnrollmentStatus {
        case open
        case closed
        case waiting
    }
    
    let number: String
    let creditHours: Int
    let waitTotal: Int
    let waitCapacity: Int
    let enrollmentTotal: Int
    let enrollmentCapacity: Int
    let availableSeats: Int
    
    let sectionType: String
    let sectionTypeName: String
    
    let academicGroup: String
    let sessionDescription: String
    
    
    var description: String {
        get {
            return "\(number)"
        }
    }
    
    required init(json: NSDictionary, sectionNumber: String) {
        
        self.number = sectionNumber
        self.creditHours = json["CreditHours"] as? Int ?? 0
        self.waitTotal = json["WaitTotal"] as? Int ?? 0
        self.waitCapacity = json["WaitCapacity"] as? Int ?? 0
        self.enrollmentTotal = json["EnrollmentTotal"] as? Int ?? 0
        self.enrollmentCapacity = json["EnrollmentCapacity"] as? Int ?? 0
        self.availableSeats = json["AvailableSeats"] as? Int ?? 0
        self.sectionType = json["SectionType"] as? String ?? "?"
        self.sectionTypeName = json["SectionTypeDescr"] as? String ?? "?"
        self.academicGroup = json["Acad_Group"] as? String ?? "?"
        self.sessionDescription = json["SessionDescr"] as? String ?? "?"
    }
}
