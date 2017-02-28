//
//  EventTableViewCell.swift
//  M Scheduler
//
//  Created by 叶亚鑫 on 15/12/10.
//  Copyright © 2015年 SubWay. All rights reserved.
//

import UIKit
import EventKit

class EventTableViewCell: UITableViewCell {
    
    var sections = false
    var instructors = [Instructor]()
    var textbooks = [Textbook]()
    var meetings = [Meeting]()
    var selectedTerm: Term!
    var selectedSchool: School!
    var selectedSubject: Subject!
    var selectedCourse: Course!
    var selectedSection: Section!
    
    // Event Variable Declaration
    var savedEventId : String = ""
    
    
    var startingDate = NSDate()
    var endingDate = NSDate()
    
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
    }
    
    // Removes an event from the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func deleteEvent(eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.eventWithIdentifier(eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.removeEvent(eventToRemove!, span: .ThisEvent)
            } catch {
                print("Bad things happened")
            }
        }
    }
    
    let eventStore = EKEventStore()
    

    // Remove Event
    


    
    @IBAction func addEventButton(sender: UIButton) {
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(self.eventStore, title: self.selectedSubject.description + " " + self.selectedCourse.description, startDate: self.startingDate, endDate: self.endingDate)
            })
        } else {
            createEvent(eventStore, title: self.selectedSubject.description + " " + self.selectedCourse.description, startDate: startingDate, endDate: endingDate)
        }
    }
    @IBOutlet weak var displayAddEventButton: UIButton!

    @IBAction func removeEventButton(sender: UIButton) {
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) -> Void in
                self.deleteEvent(self.eventStore, eventIdentifier: self.savedEventId)
            })
        } else {
            deleteEvent(eventStore, eventIdentifier: savedEventId)
        }
    }

    
    @IBOutlet weak var displayRemoveEventButton: UIButton!

    
}
