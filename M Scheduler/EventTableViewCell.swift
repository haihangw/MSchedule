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
    
    // create the variables that is used for setting up events in the calender
    var sections = false
    var instructors = [Instructor]()
    var textbooks = [Textbook]()
    var meetings = [Meeting]()
    var selectedTerm: Term!
    var selectedSchool: School!
    var selectedSubject: Subject!
    var selectedCourse: Course!
    var selectedSection: Section!
    
    // Event Variable Declaration, which is going to be used in the event creation functions
    var savedEventId : String = ""
    var EventArr = [String]()
    
    var startingDate = Date()
    var endingDate = Date()
    var startingDateLastDay = Date()
    var endingDateLastDay = Date()
    
    var arrayOfMeetingDayStarting = [Date]()
    var arrayOfMeetingDayEnding = [Date]()
    var meetingTime = 0
    
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
        
        // create the event that is going to be added in the calendar
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            // add the event into the calendar
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
            EventArr.append(savedEventId)
        } catch {
            // display message to indication error
            print("Bad things happened")
        }
    }
    
    // Removes an event from the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func deleteEvent(_ eventStore: EKEventStore, eventIdentifier: String) {
        // identify the event that is going to be removed
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if (eventToRemove != nil) {
            do {
                // remove the event
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            } catch {
                // display message to indicate error if happens
                print("Bad things happened")
            }
        }
    }
    
    // get the weekday of the NSDate
    func getDayOfWeek(_ dateOfDay: Date) -> Int {
        // create the calendar as a NSCalendar
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        // create the components of the date
        let myComponents = (myCalendar as NSCalendar?)?.components(NSCalendar.Unit.weekday, from: dateOfDay)
        // return the corresponding day of a week
        let weekDay = myComponents?.weekday
        return weekDay!
    }
    
    // create the event the is going to be edited
    let eventStore = EKEventStore()
    
    // create the add event button to add event into the calendar app
    @IBAction func addEventButton(_ sender: UIButton) {
        
        // periodically incrementing the date of the class
        for j in 0..<meetingTime {
            var endDate = arrayOfMeetingDayEnding[j]
            for var Date = arrayOfMeetingDayStarting[j]; Date.isGreaterThanDate(endingDateLastDay) == false; Date = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 7, to: Date, options: NSCalendar.Options(rawValue: 0))! {
                if (arrayOfMeetingDayStarting[j].isLessThanDate(startingDate) == false) {
                    if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                        eventStore.requestAccess(to: .event, completion: {_,_ in
                        })
                    } else {
                        createEvent(eventStore, title: self.selectedSubject.description + " " + self.selectedCourse.description, startDate: Date, endDate: endDate)
                    }
                }
                endDate = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 7, to: endDate, options: NSCalendar.Options(rawValue: 0))!
            }
        }
    }
    
    // create the outlet button displaying the text content of the button
    @IBOutlet weak var displayAddEventButton: UIButton!

    // create the remove button to remove the class from the calendar
    @IBAction func removeEventButton(_ sender: UIButton) {
        // if the user has not authorize the app to access calendar, do not remove
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                self.deleteEvent(self.eventStore, eventIdentifier: self.savedEventId)
            })
        } else {
            // else remove each class section from the calendar
            for e in EventArr {
                deleteEvent(eventStore, eventIdentifier: e)
            }
        }
    }

    // create the outlet to display the button text content
    @IBOutlet weak var displayRemoveEventButton: UIButton!

    
}
