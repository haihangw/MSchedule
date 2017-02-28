//
//  Meeting.swift
//  Scheduler
//
//  Created by Maxim Aleksa on 11/5/15.
//  Copyright © 2015 Maxim Aleksa. All rights reserved.
//

import Foundation

class Meeting: CustomStringConvertible, JSONInitializable {
    
    let startDate: String
    let endDate: String
    let meetingNumber: Int
    let times: String
    let days: String
    let instructorName: String
    let location: String
    let topicDescription: String?
    
    var description: String {
        get {
            return times
        }
    }
    
    required init(json: NSDictionary) {
        
        self.startDate = json["StartDate"] as? String ?? "?"
        self.endDate = json["EndDate"] as? String ?? "?"
        self.meetingNumber = json["MeetingNumber"] as? Int ?? 0
        self.times = json["Times"] as? String ?? "?"
        self.days = json["Days"] as? String ?? "?"
        self.instructorName = json["InstructorName"] as? String ?? "?"
        self.location = json["Location"] as? String ?? "?"
        self.topicDescription = json["TopicDescr"] as? String
    }
}
