//
//  SectionDetailsTableViewController.swift
//  M Scheduler
//
//  Created by 叶亚鑫 on 15/11/27.
//  Copyright © 2015年 SubWay. All rights reserved.
//

import UIKit
import EventKit


class SectionDetailsTableViewController: UITableViewController {
    
    
    
    
    
    
    
    
    
    
    
    
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
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // hide empty cells below
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // set up the size of the row that contains the details of the class
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // load the section details for the course from API to fill the Section variable
        CoursesAPIManager.loadSectionDetailsForSectionNumber(selectedSection!.description, andCourse: selectedCourse!, andSubject: selectedSubject!, andSchool: selectedSchool!, andTerm: selectedTerm!) { (sectionDetailsFromAPI) -> Void in
            self.selectedSection = sectionDetailsFromAPI
            self.sections = true
            // load the data from the main thread
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
            }
        }
        
        
        
        // load the instructors' information from the APT to fill the Instructor array
        CoursesAPIManager.loadInstructorsForSectionNumber(selectedSection!.description, andCourse: selectedCourse!, andSubject: selectedSubject!, andSchool: selectedSchool!, andTerm: selectedTerm!) { (instructorsFromAPI) -> Void in
            self.instructors = instructorsFromAPI
            self.sections = true
            // load the data from the main thread
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
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
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
            }
        }
        
        // load the Meetings' information from the API to fill the Meeting array
        CoursesAPIManager.loadMeetingsForSectionNumber(selectedSection!.description, andCourse: selectedCourse!, andSubject: selectedSubject!, andSchool: selectedSchool!, andTerm: selectedTerm!) { (meetingsFromAPI) -> Void in
            self.meetings = meetingsFromAPI
            self.sections = true
            // load the data from the main thread
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        // there are four sections which represent the section details,
        // instructors, textbooks and meetings
        return 6
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        
        if section == 0 {
            return 1
        } else if section == 1{
            // the first section display section details in one row
            return 1
        } else if section == 2 {
            // if there is no instructors, return one row to display no
            // instructors message
            if instructors.count == 0 {
                return 1
            } else {
                // return the number of instructors to contain all the instuctors
                return 1
            }
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
    

    
    
    
    
    
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Calendar Cell", forIndexPath: indexPath) as! CalendarTableViewCell
            
            cell.addedButton.setTitle("Add to Calendar", forState: .Normal)
            
            cell.favedButton.setTitle("Add to Favorite", forState: .Normal)
            
            
            return cell
            
        } else if indexPath.section == 1 {
            // when the section is loading, display the activity indicator
            if !sections {
                let cell = tableView.dequeueReusableCellWithIdentifier("Loading Cell", forIndexPath: indexPath)
                return cell
            } else {
                // set the cell as the Section Details Cell when this is the first section
                let cell = tableView.dequeueReusableCellWithIdentifier("Section Details Cell", forIndexPath: indexPath)
                
                // display section details when this is the first section
                cell.textLabel?.text = "Credits: " + String(selectedSection.creditHours) + "\nTotal Waitlist: " + String(selectedSection.waitTotal) + "\nWaitlist Capacity: " + String(selectedSection.waitCapacity) + "\nTotal Enrollment: " + String(selectedSection.enrollmentTotal) + "\nEnrollment Capacity: " + String(selectedSection.enrollmentCapacity) + "\nAvailable Seats: " + String(selectedSection.availableSeats) + "\nSection Type Name: " + String(selectedSection.sectionTypeName) + "\nAcademic Group: " + selectedSection.academicGroup + "\nSession Description: " + selectedSection.sessionDescription
                return cell
            }
        } else if indexPath.section == 2 {
            // when the section is loading, display the activity indicator
            if !sections {
                let cell = tableView.dequeueReusableCellWithIdentifier("Loading Cell", forIndexPath: indexPath)
                return cell
            } else {
                // set the cell as the Instructor Cell when this is the second section
                let cell = tableView.dequeueReusableCellWithIdentifier("Instructor Cell", forIndexPath: indexPath) as! EmailInstructorTableViewCell
                
                
                
                // display the instructors when this is the second section
                if instructors.count == 0 {
                    // display No Instructors when there is no instructors
                    cell.displayInstructorNameButton.setTitle("No Instructors", forState: .Normal)
                } else {
                    cell.displayInstructorNameButton.setTitle(instructors[indexPath.row].role + ": " + instructors[indexPath.row].lastName + ", " + instructors[indexPath.row].firstName, forState: .Normal)
                    
                    
                }
                return cell
            }
        } else if indexPath.section == 3 {
            // when the section is loading, display the activity indicator
            if !sections {
                let cell = tableView.dequeueReusableCellWithIdentifier("Loading Cell", forIndexPath: indexPath)
                return cell
            } else {
                // set the cell as the Textbook Cell when this is the third section
                let cell = tableView.dequeueReusableCellWithIdentifier("Textbook Cell", forIndexPath: indexPath)
                
                // display the textbooks when this is the second section
                if textbooks.count == 0 {
                    // display No Textbooks when the Textbook array is empty
                    cell.textLabel?.text = "No Textbooks"
                } else {
                    
                    // determine the value of author
                    var authorDisplay = ""
                    if textbooks[indexPath.row].author == "?" {
                        authorDisplay = "unknown author"
                    } else {
                        authorDisplay = textbooks[indexPath.row].author
                    }
                    
                    // determine the value of publisher
                    var publisherDisplay = ""
                    if textbooks[indexPath.row].publisher == "?" {
                        publisherDisplay = "unknown publisher"
                    } else {
                        publisherDisplay = textbooks[indexPath.row].publisher
                    }
                    
                    // determine the value of edition
                    var editionDisplay = ""
                    if textbooks[indexPath.row].edition == "?" {
                        editionDisplay = "unknown edition"
                    } else {
                        editionDisplay = textbooks[indexPath.row].edition
                    }
                    
                    // determine the value of publication location
                    var publicationLocationDisplay = ""
                    if textbooks[indexPath.row].publicationLocation == "?" {
                        publicationLocationDisplay = "unknown publication location"
                    } else {
                        publicationLocationDisplay = textbooks[indexPath.row].publicationLocation
                    }
                    
                    // determine the value of publication year
                    var publicationYearDisplay = ""
                    if textbooks[indexPath.row].publicationYear == 0 {
                        publicationYearDisplay = "unknown publication year"
                    } else {
                        publicationYearDisplay = String(textbooks[indexPath.row].publicationYear)
                    }
                    
                    cell.textLabel?.text = textbooks[indexPath.row].itemType + ":" + "\nISBN: " + textbooks[indexPath.row].ISBN + "\n" + textbooks[indexPath.row].description + ", Author: " + authorDisplay + ", Published by " + publisherDisplay + ", " + editionDisplay + ", " + publicationLocationDisplay + ", " + publicationYearDisplay + "\n" + textbooks[indexPath.row].requirementStatus
                }
                return cell
            }
            
        } else {
            // when the section is loading, display the activity indicator
            if !sections {
                let cell = tableView.dequeueReusableCellWithIdentifier("Loading Cell", forIndexPath: indexPath)
                return cell
            } else if indexPath.section == 4 {
                // set the cell as the Meeting Cell when this is the fourth section
                let cell = tableView.dequeueReusableCellWithIdentifier("Meeting Cell", forIndexPath: indexPath)
                
                // display the Meetings
                if meetings.count == 0 {
                    // display No Meetings when the Meetings array is empty
                    cell.textLabel?.text = "No Meetings Available at This Moment"
                } else {
                    
                    // set the topic as the topicDescription or No Topic Description
                    // if the topic of the class is empty
                    let topicDescr = meetings[indexPath.row / 7].topicDescription ?? "No Topic Description Available"
                    
                    switch indexPath.row % 7 {
                    case 0: cell.textLabel?.text = "Meeting Number: " + String(meetings[indexPath.row / 7].meetingNumber)
                    case 1: cell.textLabel?.text = "Start Date: " + meetings[indexPath.row / 7].startDate
                    case 2: cell.textLabel?.text = "End Date: " + meetings[indexPath.row / 7].endDate
                    case 3: cell.textLabel?.text = "Day/Time: " + meetings[indexPath.row / 7].days + " " + meetings[indexPath.row / 7].times
                    case 4: cell.textLabel?.text = "Instructor Name: " + meetings[indexPath.row / 7].instructorName
                    case 5: let cell = tableView.dequeueReusableCellWithIdentifier("Location Cell", forIndexPath: indexPath)
                    cell.textLabel?.text = "Locations: " + meetings[indexPath.row / 7].location
                    return cell
                    case 6: cell.textLabel?.text = "Topic Description: " + topicDescr
                    default: cell.textLabel?.text = ""
                    }
                }
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("Event Cell", forIndexPath: indexPath) as! EventTableViewCell
                
                cell.displayAddEventButton.setTitle("Add Class", forState: .Normal)
                cell.displayRemoveEventButton.setTitle("Remove Class", forState: .Normal)
                
                
                let startingDateComponent = NSDateComponents()
                let endingDateComponent = NSDateComponents()
                startingDateComponent.year = self.selectedTerm.year
                endingDateComponent.year = startingDateComponent.year
                
                
                if meetings.count != 0 {
                    
                    let startingDateMonthFirstDigit = meetings[indexPath.row].startDate[0]
                    let startingDateMonthSecondDigit = meetings[indexPath.row].startDate[1]
                    var startingDateMonthComponentString = ""
                    startingDateMonthComponentString.append(startingDateMonthFirstDigit)
                    startingDateMonthComponentString.append(startingDateMonthSecondDigit)
                    startingDateComponent.month = Int(startingDateMonthComponentString)!
                    endingDateComponent.month = startingDateComponent.month
                    
                    let startingDateDayFirstDigit = meetings[indexPath.row].startDate[3]
                    let startingDateDaySecondDigit = meetings[indexPath.row].startDate[4]
                    var startingDateDayComponentString = ""
                    startingDateDayComponentString.append(startingDateDayFirstDigit)
                    startingDateDayComponentString.append(startingDateDaySecondDigit)
                    startingDateComponent.day = Int(startingDateDayComponentString)!
                    endingDateComponent.day = startingDateComponent.day
                    
                    
                    var startingDateHourComponentString = ""
                    var endingDateHourComponentString = ""
                    if meetings[indexPath.row].times.characters.count == 15 {
                        let startingDateHourFirstDigit = meetings[indexPath.row].times[0]
                        startingDateHourComponentString.append(startingDateHourFirstDigit)
                        let endingDateHourFirstDigit = meetings[indexPath.row].times[9]
                        endingDateHourComponentString.append(endingDateHourFirstDigit)
                        
                        
                        if meetings[indexPath.row].times[4] == "P" {
                            startingDateComponent.hour = Int(startingDateHourComponentString)! + 12
                            endingDateComponent.hour = Int(endingDateHourComponentString)! + 12
                        } else {
                            startingDateComponent.hour = Int(startingDateHourComponentString)!
                            endingDateComponent.hour = Int(endingDateHourComponentString)!
                        }
                    } else if meetings[indexPath.row].times.characters.count == 16 {
                        if meetings[indexPath.row].times[0] == "8" || meetings[indexPath.row].times[0] == "9" {
                            let startingDateHourFirstDigit = meetings[indexPath.row].times[0]
                            startingDateHourComponentString.append(startingDateHourFirstDigit)
                            let endingDateHourFirstDigit = meetings[indexPath.row].times[9]
                            let endingDateHourSecondDigit = meetings[indexPath.row].times[10]
                            endingDateHourComponentString.append(endingDateHourFirstDigit)
                            endingDateHourComponentString.append(endingDateHourSecondDigit)
                            startingDateComponent.hour = Int(startingDateHourComponentString)!
                            endingDateComponent.hour = Int(endingDateHourComponentString)!
                        } else {
                            let startingDateHourFirstDigit = meetings[indexPath.row].times[0]
                            let startingDateHourSecondDigit = meetings[indexPath.row].times[1]
                            startingDateHourComponentString.append(startingDateHourFirstDigit)
                            startingDateHourComponentString.append(startingDateHourSecondDigit)
                            let endingDateHourFirstDigit = meetings[indexPath.row].times[10]
                            endingDateHourComponentString.append(endingDateHourFirstDigit)
                            startingDateComponent.hour = Int(startingDateHourComponentString)!
                            endingDateComponent.hour = Int(endingDateHourComponentString)! + 12
                        }
                    } else if meetings[indexPath.row].times.characters.count == 17 {
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
                    
                    var startingDateMinComponentString = ""
                    var endingDateMinComponentString = ""
                    if meetings[indexPath.row].times.characters.count == 15 {
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
                        if meetings[indexPath.row].times[0] == "8" || meetings[indexPath.row].times[0] == "9" {
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
                            
                        } else {
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
                        }
                        
                    } else if meetings[indexPath.row].times.characters.count == 17 {
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
                    
                    startingDateComponent.second = 0
                    endingDateComponent.second = 0
                    let userCalendar = NSCalendar.currentCalendar()
                    let startingDate = userCalendar.dateFromComponents(startingDateComponent)
                    let endingDate = userCalendar.dateFromComponents(endingDateComponent)
                    
                    cell.startingDate = startingDate!
                    cell.endingDate = endingDate!
                    cell.selectedTerm = selectedTerm
                    cell.selectedSchool = selectedSchool
                    cell.selectedSubject = selectedSubject
                    cell.selectedCourse = selectedCourse
                    
                }
                
                
                return cell
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            // return first section header
            return "Section Details: "
        } else if section == 2 {
            // return second section header
            return "Instructors:"
        } else if section == 3 {
            // return third section header
            return "Textbooks: "
        } else if section == 4 {
            // return fourth section header
            return "Meetings: "
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // mvc: MapViewController, link to the next TableViewController
        if let mvc = segue.destinationViewController as? MapViewController {
            if segue.identifier == "Display Map" {
                // set up the index of the selected section
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    // set up the information of the selected class
                    mvc.title = "Map"
                    mvc.meetingLocation = meetings[indexPath.row / 7].location
                }
            }
        }
    }
}
