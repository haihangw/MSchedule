//
//  SectionDetailsTableViewController.swift
//  M Scheduler
//
//  Created by 叶亚鑫 on 15/11/27.
//  Copyright © 2015年 SubWay. All rights reserved.
//

import UIKit
import EventKit
import MessageUI


class SectionDetailsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Model
    
    // create the arrays of type Instructor, Textbook and Meeting for the class details
    var sections = false
    var instructors = [Instructor]()
    var textbooks = [Textbook]()
    var meetings = [Meeting]()
    var selectedTerm: Term!
    var selectedSchool: School!
    var selectedSubject: Subject!
    var selectedCourse: Course!
    var selectedSection: Section!
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // hide empty cells below
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // set up the size of the row that contains the details of the class
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // load the section details for the course from API to fill the Section variable
        CoursesAPIManager.loadSectionDetailsForSectionNumber(selectedSection!.description, andCourse: selectedCourse!, andSubject: selectedSubject!, andSchool: selectedSchool!, andTerm: selectedTerm!) { (sectionDetailsFromAPI) -> Void in
            self.selectedSection = sectionDetailsFromAPI
            self.sections = true
            // load the data from the main thread
            DispatchQueue.main.async { () -> Void in
                self.tableView.reloadData()
            }
        }
        
        // load the instructors' information from the APT to fill the Instructor array
        CoursesAPIManager.loadInstructorsForSectionNumber(selectedSection!.description, andCourse: selectedCourse!, andSubject: selectedSubject!, andSchool: selectedSchool!, andTerm: selectedTerm!) { (instructorsFromAPI) -> Void in
            self.instructors = instructorsFromAPI
            self.sections = true
            // load the data from the main thread
            DispatchQueue.main.async { () -> Void in
                self.tableView.reloadData()
                
                // let email = "@umich.edu"
                // let url = NSURL(string: "mailto:\(email)")!
                // UIApplication.sharedApplication().openURL(url)
            }
        }
        
        // load the Textbooks' information from the API to fill the Textbook array
        CoursesAPIManager.loadTextbooksForSectionNumber(selectedSection!.description, andCourse: selectedCourse!, andSubject: selectedSubject!, andSchool: selectedSchool!, andTerm: selectedTerm!) { (textbooksFromAPI) -> Void in
            self.textbooks = textbooksFromAPI
            self.sections = true
            // load the data from the main thread
            DispatchQueue.main.async { () -> Void in
                self.tableView.reloadData()
            }
        }
        
        // load the Meetings' information from the API to fill the Meeting array
        CoursesAPIManager.loadMeetingsForSectionNumber(selectedSection!.description, andCourse: selectedCourse!, andSubject: selectedSubject!, andSchool: selectedSchool!, andTerm: selectedTerm!) { (meetingsFromAPI) -> Void in
            self.meetings = meetingsFromAPI
            self.sections = true
            // load the data from the main thread
            DispatchQueue.main.async { () -> Void in
                self.tableView.reloadData()
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        // there are four sections which represent the section details,
        // instructors, textbooks and meetings
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            return 1
        } else if section == 1{
            // the first section display section details in one row
            return 1
        } else if section == 2 {
            // if there is no instructors, return one row to display no
            // instructors message
            return instructors.count
        } else if section == 3 {
            if textbooks.count == 0 {
                // if there is no textbook require, return one row to
                // indicate no textbook message
                return 1
            } else {
                // else return the number of textbooks to represent all the textbooks
                return textbooks.count
            }
        } else if section == 4 {
            if meetings.count ==  0 {
                // return one row to indicate no meeting message if there is no meeting
                return 1
            } else {
                // return the number of meetings of rows to represent all the meetings
                return meetings.count * 7
            }
        } else if section == 5 {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Schedule&Favorite Cell", for: indexPath) as! CalendarTableViewCell
            
            let addToSchedule = NSLocalizedString("Add to Schedule", comment: "-Add to Schedule")
            let addToFavorite = NSLocalizedString("Add to Favorite", comment: "-Add to Favorite")
            
            cell.addedButton.setTitle(addToSchedule, for: UIControlState())
            
            cell.favedButton.setTitle(addToFavorite, for: UIControlState())
            
            cell.selectedSection = selectedSection
            cell.selectedCourse = selectedCourse
            cell.selectedSubject = selectedSubject
            cell.selectedSchool = selectedSchool
            cell.selectedTerm = selectedTerm
            
            let favCourse: String! = selectedTerm!.description + " " + selectedSchool!.description + " " + selectedSubject!.description + " " + selectedCourse!.description + " " + selectedSection!.description
            
            if var favCourses = userDefaults.array(forKey: "Favorite") as? [String] {
                let remoFromFavorite = NSLocalizedString("Remove from Favorite", comment: "-Remove from Favorite")
                if favCourses.contains(favCourse) {
                    cell.favedButton.setTitle(remoFromFavorite, for: UIControlState())
                }
            }
            
            
            return cell
            
        } else if indexPath.section == 1 {
            // when the section is loading, display the activity indicator
            if !sections {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
            } else {
                // set the cell as the Section Details Cell when this is the first section
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section Details Cell", for: indexPath)
                let credits = NSLocalizedString("Credits: ", comment: "-Credits: ")
                let totalWaitlist = NSLocalizedString("Total Waitlist: ", comment: "-\nTotal Waitlist: ")
                let waitlistCapacity = NSLocalizedString("Waitlist Capacity: ", comment: "-\nWaitlist Capacity: ")
                let totalEnrollment = NSLocalizedString("Total Enrollment: ", comment: "-\nTotal Enrollment: ")
                let enrollmentCapacity = NSLocalizedString("Enrollment Capacity: ", comment: "-\nEnrollment Capacity: ")
                let availableSeats = NSLocalizedString("Available Seats: ", comment: "-\nAvailable Seats: ")
                let sectionTypeName = NSLocalizedString("Section Type Name: ", comment: "-\nSection Type Name: ")
                let academicGroup = NSLocalizedString("Academic Group: ", comment: "-\nAcademic Group: ")
                let sectionDescription = NSLocalizedString("Session Description: ", comment: "-\nSession Description: ")
                
                // display section details when this is the first section
                cell.textLabel?.text = credits + String(selectedSection.creditHours) + "\n" + totalWaitlist + String(selectedSection.waitTotal) + "\n" + waitlistCapacity + String(selectedSection.waitCapacity) + "\n" + totalEnrollment + String(selectedSection.enrollmentTotal) + "\n" + enrollmentCapacity + String(selectedSection.enrollmentCapacity) + "\n" + availableSeats + String(selectedSection.availableSeats) + "\n" + sectionTypeName + String(selectedSection.sectionTypeName) + "\n" + academicGroup + selectedSection.academicGroup + "\n" + sectionDescription + selectedSection.sessionDescription
                return cell
            }
            
        } else if indexPath.section == 2 {
            // when the section is loading, display the activity indicator
            if !sections {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
            } else {
                // set the cell as the Instructor Cell when this is the second section
                let cell = tableView.dequeueReusableCell(withIdentifier: "Instructor Cell", for: indexPath)
                
                
                // display the instructors when this is the second section
                if instructors[indexPath.row].role == "?" && instructors[indexPath.row].firstName == "?" && instructors[indexPath.row].lastName == "?" {
                    // display No Instructors when there is no instructors
                    let noInstructors = NSLocalizedString("No Instructors", comment: "-No Instructors")
                    cell.textLabel?.text = noInstructors
                } else {
                    cell.textLabel?.text = instructors[indexPath.row].role + ": " + instructors[indexPath.row].lastName + ", " + instructors[indexPath.row].firstName
                }
                return cell
            }
        } else if indexPath.section == 3 {
            // when the section is loading, display the activity indicator
            if !sections {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
            } else {
                // set the cell as the Textbook Cell when this is the third section
                let cell = tableView.dequeueReusableCell(withIdentifier: "Textbook Cell", for: indexPath)
                
                // display the textbooks when this is the second section
                if textbooks.count == 0 {
                    // display No Textbooks when the Textbook array is empty
                    let noTextbooks = NSLocalizedString("No Textbooks", comment: "-No Textbooks")
                    cell.textLabel?.text = noTextbooks
                } else {
                    
                    // determine the value of author
                    var authorDisplay = ""
                    if textbooks[indexPath.row].author == "?" {
                        authorDisplay = ""
                    } else {
                        authorDisplay = textbooks[indexPath.row].author
                    }
                    
                    // determine the value of publisher
                    var publisherDisplay = ""
                    if textbooks[indexPath.row].publisher == "?" {
                        publisherDisplay = ""
                    } else {
                        publisherDisplay = textbooks[indexPath.row].publisher
                    }
                    
                    // determine the value of edition
                    var editionDisplay = ""
                    if textbooks[indexPath.row].edition == "?" {
                        editionDisplay = ""
                    } else {
                        editionDisplay = textbooks[indexPath.row].edition
                    }
                    
                    // determine the value of publication location
                    var publicationLocationDisplay = ""
                    if textbooks[indexPath.row].publicationLocation == "?" {
                        publicationLocationDisplay = ""
                    } else {
                        publicationLocationDisplay = textbooks[indexPath.row].publicationLocation
                    }
                    
                    // determine the value of publication year
                    var publicationYearDisplay = ""
                    if textbooks[indexPath.row].publicationYear == 0 {
                        publicationYearDisplay = ""
                    } else {
                        publicationYearDisplay = String(textbooks[indexPath.row].publicationYear)
                    }
                    
                    let AAuthor = NSLocalizedString(", Author: ", comment: "-, Author: ")
                    let APublishedBy = NSLocalizedString(", Published by ", comment: ", Published by ")
                    
                    cell.textLabel?.text = textbooks[indexPath.row].itemType + ":" + "\nISBN: " + textbooks[indexPath.row].ISBN + "\n" + textbooks[indexPath.row].description + AAuthor + authorDisplay + APublishedBy + publisherDisplay + ", " + editionDisplay + ", " + publicationLocationDisplay + ", " + publicationYearDisplay + "\n" + textbooks[indexPath.row].requirementStatus
                }
                return cell
            }
            
        } else {
            // when the section is loading, display the activity indicator
            if !sections {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
            } else if indexPath.section == 4 {
                // set the cell as the Meeting Cell when this is the fourth section
                let cell = tableView.dequeueReusableCell(withIdentifier: "Meeting Cell", for: indexPath)
                
                // display the Meetings
                if meetings.count == 0 {
                    // display No Meetings when the Meetings array is empty
                    let noMeetAvail = NSLocalizedString("No Meetings Available at This Moment", comment: "-No Meetings Available at This Moment")
                    cell.textLabel?.text = noMeetAvail
                } else {
                    
                    // set the topic as the topicDescription or No Topic Description
                    // if the topic of the class is empty
                    let noTopicDescAvail = NSLocalizedString("No Topic Description Available", comment: "-No Topic Description Available")
                    let topicDescr = meetings[indexPath.row / 7].topicDescription ?? noTopicDescAvail
                    
                    let AmeetingNumber = NSLocalizedString("Meeting Number: ", comment: "-Meeting Number: ")
                    let AstartDate = NSLocalizedString("Start Date: ", comment: "-Start Date: ")
                    let AendDate = NSLocalizedString("End Date: ", comment: "-End Date: ")
                    let AdayTime = NSLocalizedString("Day/Time: ", comment: "-Day/Time: ")
                    let AinstructorName = NSLocalizedString("Instructor Name: ", comment: "-Instructor Name: ")
                    let Alocations = NSLocalizedString("Locations: ", comment: "-Locations: ")
                    let AtopicDescription = NSLocalizedString("Topic Description: ", comment: "-Topic Description: ")
                    
                    switch indexPath.row % 7 {
                    case 0: cell.textLabel?.text = AmeetingNumber + String(meetings[indexPath.row / 7].meetingNumber)
                    case 1: cell.textLabel?.text = AstartDate + meetings[indexPath.row / 7].startDate
                    case 2: cell.textLabel?.text = AendDate + meetings[indexPath.row / 7].endDate
                    case 3: cell.textLabel?.text = AdayTime + meetings[indexPath.row / 7].days + " " + meetings[indexPath.row / 7].times
                    case 4: cell.textLabel?.text = AinstructorName + meetings[indexPath.row / 7].instructorName
                    case 5: let cell = tableView.dequeueReusableCell(withIdentifier: "Location Cell", for: indexPath)
                    cell.textLabel?.text = Alocations + meetings[indexPath.row / 7].location
                    return cell
                    case 6: cell.textLabel?.text = AtopicDescription + topicDescr
                    default: cell.textLabel?.text = ""
                    }
                }
                return cell
            } else {
                
                // declare the cell identifier corresponding in the main story board
                let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell", for: indexPath) as! EventTableViewCell
                
                // declare the button of the adding and removing event
                let addClass = NSLocalizedString("Add to Calendar", comment: "-Add to Calendar")
                let remoClass = NSLocalizedString("Remove from Calendar", comment: "-Remove from Calendar")
                cell.displayAddEventButton.setTitle(addClass, for: UIControlState())
                cell.displayRemoveEventButton.setTitle(remoClass, for: UIControlState())
                
                // create NSDate variables for creating class dates
                var startingDateComponent = DateComponents()
                var endingDateComponent = DateComponents()
                var startingDateLastDayComponent = DateComponents()
                var endingDateLastDayComponent = DateComponents()
                startingDateComponent.year = self.selectedTerm.year
                endingDateComponent.year = startingDateComponent.year
                startingDateLastDayComponent.year = endingDateComponent.year
                endingDateLastDayComponent.year = endingDateComponent.year
                
                if meetings.count != 0 {
                    
                    // Determine the month of the first class
                    let startingDateMonthFirstDigit = meetings[indexPath.row].startDate[0]
                    let startingDateMonthSecondDigit = meetings[indexPath.row].startDate[1]
                    var startingDateMonthComponentString = ""
                    startingDateMonthComponentString.append(startingDateMonthFirstDigit)
                    startingDateMonthComponentString.append(startingDateMonthSecondDigit)
                    startingDateComponent.month = Int(startingDateMonthComponentString)!
                    endingDateComponent.month = startingDateComponent.month
                    
                    // Determine the month of the last class
                    let startingDateMonthLastDayFirstDigit = meetings[indexPath.row].endDate[0]
                    let startingDateMonthLastDaySecondDigit = meetings[indexPath.row].endDate[1]
                    var startingDateMonthLastDayComponentString = ""
                    startingDateMonthLastDayComponentString.append(startingDateMonthLastDayFirstDigit)
                    startingDateMonthLastDayComponentString.append(startingDateMonthLastDaySecondDigit)
                    startingDateLastDayComponent.month = Int(startingDateMonthLastDayComponentString)!
                    endingDateLastDayComponent.month = startingDateLastDayComponent.month
                    
                    // Determine the day of the first class
                    let startingDateDayFirstDigit = meetings[indexPath.row].startDate[3]
                    let startingDateDaySecondDigit = meetings[indexPath.row].startDate[4]
                    var startingDateDayComponentString = ""
                    startingDateDayComponentString.append(startingDateDayFirstDigit)
                    startingDateDayComponentString.append(startingDateDaySecondDigit)
                    startingDateComponent.day = Int(startingDateDayComponentString)!
                    endingDateComponent.day = startingDateComponent.day
                    
                    // Determine the day of the last class
                    let startingDateDayLastDayFirstDigit = meetings[indexPath.row].endDate[3]
                    let startingDateDayLastDaySecondDigut = meetings[indexPath.row].endDate[4]
                    var startingDateDayLastDayComponentString = ""
                    startingDateDayLastDayComponentString.append(startingDateDayLastDayFirstDigit)
                    startingDateDayLastDayComponentString.append(startingDateDayLastDaySecondDigut)
                    startingDateLastDayComponent.day = Int(startingDateDayLastDayComponentString)!
                    endingDateLastDayComponent.day = startingDateLastDayComponent.day
                    
                    // determine the time of the hour of the class in a day
                    var startingDateHourComponentString = ""
                    var endingDateHourComponentString = ""
                    if meetings[indexPath.row].times.characters.count == 15 {
                        // when the class time string has 15 digits
                        let startingDateHourFirstDigit = meetings[indexPath.row].times[0]
                        startingDateHourComponentString.append(startingDateHourFirstDigit)
                        let endingDateHourFirstDigit = meetings[indexPath.row].times[9]
                        endingDateHourComponentString.append(endingDateHourFirstDigit)
                        
                        if meetings[indexPath.row].times[4] == "P" {
                            // add 12 when the class happens in the afternoon
                            startingDateComponent.hour = Int(startingDateHourComponentString)! + 12
                            endingDateComponent.hour = Int(endingDateHourComponentString)! + 12
                        } else {
                            // keep the original time data when the class happens in the morning
                            startingDateComponent.hour = Int(startingDateHourComponentString)!
                            endingDateComponent.hour = Int(endingDateHourComponentString)!
                        }
                        
                    } else if meetings[indexPath.row].times.characters.count == 16 {
                        if meetings[indexPath.row].times[0] == "8" || meetings[indexPath.row].times[0] == "9" {
                            
                            // get the corresponding index characters
                            // when the class string has 16 digits and the class happens in the morning
                            let startingDateHourFirstDigit = meetings[indexPath.row].times[0]
                            startingDateHourComponentString.append(startingDateHourFirstDigit)
                            let endingDateHourFirstDigit = meetings[indexPath.row].times[9]
                            let endingDateHourSecondDigit = meetings[indexPath.row].times[10]
                            endingDateHourComponentString.append(endingDateHourFirstDigit)
                            endingDateHourComponentString.append(endingDateHourSecondDigit)
                            startingDateComponent.hour = Int(startingDateHourComponentString)!
                            endingDateComponent.hour = Int(endingDateHourComponentString)!
                        } else if meetings[indexPath.row].times[0] == "1" {
                            
                            // get the corresponding index characters when the class happen
                            // in the afternoon add 12 to the time data
                            let startingDateHourFirstDigit = meetings[indexPath.row].times[0]
                            let startingDateHourSecondDigit = meetings[indexPath.row].times[1]
                            startingDateHourComponentString.append(startingDateHourFirstDigit)
                            startingDateHourComponentString.append(startingDateHourSecondDigit)
                            let endingDateHourFirstDigit = meetings[indexPath.row].times[10]
                            endingDateHourComponentString.append(endingDateHourFirstDigit)
                            startingDateComponent.hour = Int(startingDateHourComponentString)!
                            endingDateComponent.hour = Int(endingDateHourComponentString)! + 12
                        } else {
                            let startingDateHourFirstDigit = meetings[indexPath.row].times[0]
                            startingDateHourComponentString.append(startingDateHourFirstDigit)
                            let endingDateHourFirstDigit = meetings[indexPath.row].times[9]
                            let endingDateHourSecondDigit = meetings[indexPath.row].times[10]
                            endingDateHourComponentString.append(endingDateHourFirstDigit)
                            endingDateHourComponentString.append(endingDateHourSecondDigit)
                            startingDateComponent.hour = Int(startingDateHourComponentString)! + 12
                            endingDateComponent.hour = Int(endingDateHourComponentString)! + 12
                            
                            
                        }
                        
                    } else if meetings[indexPath.row].times.characters.count == 17 {
                        
                        // get the corresponding index characters when the class stirng has 17 digits
                        let startingDateHourFirstDigit = meetings[indexPath.row].times[0]
                        let startingDateHourSecondDigit = meetings[indexPath.row].times[1]
                        startingDateHourComponentString.append(startingDateHourFirstDigit)
                        startingDateHourComponentString.append(startingDateHourSecondDigit)
                        let endingDateHourFirstDigit = meetings[indexPath.row].times[10]
                        let endingDateHourSecondDigit = meetings[indexPath.row].times[11]
                        endingDateHourComponentString.append(endingDateHourFirstDigit)
                        endingDateHourComponentString.append(endingDateHourSecondDigit)
                        startingDateComponent.hour = Int(startingDateHourComponentString)!
                        endingDateComponent.hour = Int(endingDateHourComponentString)!
                    }
                    
                    // determine the time of the minute of the class of a day
                    var startingDateMinComponentString = ""
                    var endingDateMinComponentString = ""
                    if meetings[indexPath.row].times.characters.count == 15 {
                        
                        // get the corresponding index characters when the class time string has 15 digits
                        let startingDateMinFirstDigit = meetings[indexPath.row].times[2]
                        let startingDateMinSecondDigit = meetings[indexPath.row].times[3]
                        startingDateMinComponentString.append(startingDateMinFirstDigit)
                        startingDateMinComponentString.append(startingDateMinSecondDigit)
                        let endingDateMinFirstDigit = meetings[indexPath.row].times[11]
                        let endingDateMinSecondDigit = meetings[indexPath.row].times[12]
                        endingDateMinComponentString.append(endingDateMinFirstDigit)
                        endingDateMinComponentString.append(endingDateMinSecondDigit)
                        startingDateComponent.minute = Int(startingDateMinComponentString)!
                        endingDateComponent.minute = Int(endingDateMinComponentString)!
                        
                    } else if meetings[indexPath.row].times.characters.count == 16 {
                        
                        // get the corresponding index characters when the class time digit has 16 digits
                        if meetings[indexPath.row].times[0] == "8" || meetings[indexPath.row].times[0] == "9" {
                            
                            // get the corresponding index characters when the class happens in the morning
                            let startingDateMinFirstDigit = meetings[indexPath.row].times[2]
                            let startingDateMinSecondDigit = meetings[indexPath.row].times[3]
                            startingDateMinComponentString.append(startingDateMinFirstDigit)
                            startingDateMinComponentString.append(startingDateMinSecondDigit)
                            let endingDateMinFirstDigit = meetings[indexPath.row].times[12]
                            let endingDateMinSecondDigit = meetings[indexPath.row].times[13]
                            endingDateMinComponentString.append(endingDateMinFirstDigit)
                            endingDateMinComponentString.append(endingDateMinSecondDigit)
                            startingDateComponent.minute = Int(startingDateMinComponentString)!
                            endingDateComponent.minute = Int(endingDateMinComponentString)!
                            
                        } else if meetings[indexPath.row].times[0] == "1" {
                            
                            // get the corresponding index characters when the class happens in
                            // the afternoon
                            let startingDateMinFirstDigit = meetings[indexPath.row].times[3]
                            let startingDateMinSecondDigit = meetings[indexPath.row].times[4]
                            startingDateMinComponentString.append(startingDateMinFirstDigit)
                            startingDateMinComponentString.append(startingDateMinSecondDigit)
                            let endingDateMinFirstDigit = meetings[indexPath.row].times[12]
                            let endingDateMinSecondDigit = meetings[indexPath.row].times[13]
                            endingDateMinComponentString.append(endingDateMinFirstDigit)
                            endingDateMinComponentString.append(endingDateMinSecondDigit)
                            startingDateComponent.minute = Int(startingDateMinComponentString)!
                            endingDateComponent.minute = Int(endingDateMinComponentString)!
                        } else {
                            let startingDateMinFirstDigit = meetings[indexPath.row].times[2]
                            let startingDateMinSecondDigit = meetings[indexPath.row].times[3]
                            startingDateMinComponentString.append(startingDateMinFirstDigit)
                            startingDateMinComponentString.append(startingDateMinSecondDigit)
                            let endingDateMinFirstDigit = meetings[indexPath.row].times[12]
                            let endingDateMinSecondDigit = meetings[indexPath.row].times[13]
                            endingDateMinComponentString.append(endingDateMinFirstDigit)
                            endingDateMinComponentString.append(endingDateMinSecondDigit)
                            startingDateComponent.minute = Int(startingDateMinComponentString)!
                            endingDateComponent.minute = Int(endingDateMinComponentString)!
                        }
                        
                    } else if meetings[indexPath.row].times.characters.count == 17 {
                        
                        // get the corresponding index characters when the class time stringh as 17 digits
                        let startingDateMinFirstDigit = meetings[indexPath.row].times[3]
                        let startingDateMinSecondDigit = meetings[indexPath.row].times[4]
                        startingDateMinComponentString.append(startingDateMinFirstDigit)
                        startingDateMinComponentString.append(startingDateMinSecondDigit)
                        let endingDateMinFirstDigit = meetings[indexPath.row].times[13]
                        let endingDateMinSecondDigit = meetings[indexPath.row].times[14]
                        endingDateMinComponentString.append(endingDateMinFirstDigit)
                        endingDateMinComponentString.append(endingDateMinSecondDigit)
                        startingDateComponent.minute = Int(startingDateMinComponentString)!
                        endingDateComponent.minute = Int(endingDateMinComponentString)!
                    }
                    
                    // the second of the class time is always zero
                    startingDateComponent.second = 0
                    endingDateComponent.second = 0
                    
                    // determine the other components of startingDateLastDayComponent and endingDateLastDayComponent
                    startingDateLastDayComponent.hour = startingDateComponent.hour
                    startingDateLastDayComponent.minute = startingDateComponent.minute
                    startingDateLastDayComponent.second = startingDateComponent.second
                    endingDateLastDayComponent.hour = endingDateComponent.hour
                    endingDateLastDayComponent.minute = endingDateComponent.minute
                    endingDateLastDayComponent.second = endingDateComponent.second
                    
                    // convert the string to the NSDate variables
                    let userCalendar = Calendar.current
                    let startingDate = userCalendar.date(from: startingDateComponent)
                    let endingDate = userCalendar.date(from: endingDateComponent)
                    let startingDateLastDay = userCalendar.date(from: startingDateLastDayComponent)
                    let endingDateLastDay = userCalendar.date(from: endingDateLastDayComponent)
                    
                    cell.startingDate = startingDate!
                    cell.endingDate = endingDate!
                    cell.startingDateLastDay = startingDateLastDay!
                    cell.endingDateLastDay = endingDateLastDay!
                    
                    cell.selectedTerm = selectedTerm
                    cell.selectedSchool = selectedSchool
                    cell.selectedSubject = selectedSubject
                    cell.selectedCourse = selectedCourse
                    
                    
                    // convert the weekday string into integers representing the days
                    var meetingWeekdayString: [String] = ["", "", "", "", ""]
                    var meetingWeekdayInt: [Int] = [0, 0, 0, 0, 0]
                    var meetingTime = 0
                    for index in 1...(meetings[indexPath.row].days.characters.count / 2) {
                        let firstDigit = meetings[indexPath.row].days[index*2-2]
                        let secondDigit = meetings[indexPath.row].days[index*2-1]
                        meetingWeekdayString[index-1].append(firstDigit)
                        meetingWeekdayString[index-1].append(secondDigit)
                        meetingTime = meetingTime + 1
                    }
                    print(meetingWeekdayString)
                    print(meetings[indexPath.row].days)
                    print("meetingTime is \(meetingTime)")
                    for i in 1...meetingTime {
                        switch meetingWeekdayString[i-1] {
                        case "Mo": meetingWeekdayInt[i-1] = 2
                        case "Tu": meetingWeekdayInt[i-1] = 3
                        case "We": meetingWeekdayInt[i-1] = 4
                        case "Th": meetingWeekdayInt[i-1] = 5
                        case "Fr": meetingWeekdayInt[i-1] = 6
                        case "Sa": meetingWeekdayInt[i-1] = 7
                        case "Su": meetingWeekdayInt[i-1] = 1
                        default: meetingWeekdayInt[i-1] = 0
                        }
                    }
                    cell.meetingTime = meetingTime
                    
                    func getDayOfWeek(_ dateOfDay: Date) -> Int {
                        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
                        let myComponents = (myCalendar as NSCalendar?)?.components(NSCalendar.Unit.weekday, from: dateOfDay)
                        let weekDay = myComponents?.weekday
                        return weekDay!
                    }
                    
                    // adding the date periodically to increment the days of the class
                    var arrayOfMeetingDayStarting: [Date] = [startingDate!, startingDate!, startingDate!, startingDate!, startingDate!]
                    var arrayOfMeetingDayEnding: [Date] = [endingDate!, endingDate!, endingDate!, endingDate!, endingDate!]
                    
                    for j in 0..<meetingTime {
                        let substraction = meetingWeekdayInt[j] - getDayOfWeek(startingDate!)
                        arrayOfMeetingDayStarting[j] = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: substraction, to: arrayOfMeetingDayStarting[j], options: NSCalendar.Options(rawValue: 0))!
                        arrayOfMeetingDayEnding[j] = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: substraction, to: arrayOfMeetingDayEnding[j], options: NSCalendar.Options(rawValue: 0))!
                        
                        
                    }
                    
                    for k in 0..<meetingTime {
                        if arrayOfMeetingDayStarting[k].isLessThanDate(startingDate!) {
                            arrayOfMeetingDayStarting[k] = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 7, to: arrayOfMeetingDayStarting[k], options: NSCalendar.Options(rawValue: 0))!
                            arrayOfMeetingDayEnding[k] = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 7, to: arrayOfMeetingDayEnding[k], options: NSCalendar.Options(rawValue: 0))!
                        }
                    }
                    print(arrayOfMeetingDayStarting)
                    print(arrayOfMeetingDayEnding)
                    
                    cell.arrayOfMeetingDayStarting = arrayOfMeetingDayStarting
                    cell.arrayOfMeetingDayEnding = arrayOfMeetingDayEnding
                }
                
                
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if indexPath corresponds to indexPath of professor
        // start email to professor, resources from the internet
        if indexPath.section == 2 {
            let instructor = instructors[indexPath.row]
            let emailTitle = ""
            let messageBody = ""
            let toRecipents = ["\(instructor.uniqname)@umich.edu"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            self.present(mc, animated: true, completion: nil)
        }
    }
    
    // indicate the status of the email sending
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionDetails = NSLocalizedString("Section Details: ", comment: "-Section Details: ")
        let instructors = NSLocalizedString("Instructors:", comment: "-Instructors:")
        let textbooks = NSLocalizedString("Textbooks: ", comment: "-Textbooks: ")
        let meetings = NSLocalizedString("Meetings: ", comment: "-Meetings: ")
        
        
        if section == 1 {
            // return first section header
            return sectionDetails
        } else if section == 2 {
            // return second section header
            return instructors
        } else if section == 3 {
            // return third section header
            return textbooks
        } else if section == 4 {
            // return fourth section header
            return meetings
        } else {
            return nil
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // mvc: MapViewController, link to the next TableViewController
        if let mvc = segue.destination as? MapViewController {
            if segue.identifier == "Display Map" {
                // set up the index of the selected section
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    // set up the information of the selected class
                    let map = NSLocalizedString("Map", comment: "-Map")
                    mvc.title = map
                    mvc.meetingLocation = meetings[indexPath.row / 7].location
                }
            }
        }
        if let fctvc = segue.destination as? FavoriteClassTableViewController {
            if segue.identifier == "fav6" {
                // set up the index for the selected section if the indentifier is Select Section
                
                // set up the title of the section and gather the information of the section
                fctvc.selectedSection = selectedSection
                fctvc.selectedCourse = selectedCourse
                fctvc.selectedSubject = selectedSubject
                fctvc.selectedSchool = selectedSchool
                fctvc.selectedTerm = selectedTerm
            }
        }
        
    }
}
