//
//  SectionTableViewController.swift
//  M Scheduler
//
//  Created by Hedge Wang on 11/26/15.
//  Copyright © 2015 SubWay. All rights reserved.
//

import UIKit

class SectionTableViewController: UITableViewController {
    
    // MARK: - Model
    
    // create the array of the type Section
    // create variables that representing the information of the selected section
    // create an empty string to contain the course description
    var sections = [Section]()
    var courseDescription: String = ""
    var selectedCourse: Course!
    var selectedSubject: Subject!
    var selectedTerm: Term!
    var selectedSchool: School!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide empty cells below
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // set up the size of the table view that contains the information of the section
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // load the course description from the API to fill the courseDescription
        // string of specific classes
        CoursesAPIManager.loadCourseDescriptionForCourse(selectedCourse!, andSubject: selectedSubject!, andSchool: selectedSchool!, andTerm: selectedTerm!) { (courseDescriptionFromAPI) -> Void in
            self.courseDescription = courseDescriptionFromAPI
            // load the data from the main thread
            DispatchQueue.main.async { () -> Void in
                self.tableView.reloadData()
            }
        }
        
        // load the course information from the API to fill the section array
        // of the specific class
        CoursesAPIManager.loadSectionsForCourse(selectedCourse!, andSubject: selectedSubject!, andSchool: selectedSchool!, andTerm: selectedTerm!) { (sectionsFromAPI) -> Void in
            self.sections = sectionsFromAPI
            // reload the data from the main thread
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
        
        // there are only two sections for the sectionTableViewController
        // one is for description and another is for class sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            // the first section only needs one row to contain the course description
            return 1
        } else if section == 1 {
            if sections.count == 0 {
                // return one row to indicate no class message
                return 1
            } else {
                // return the number of class sections to contain all the
                // class sections
                return sections.count
            }
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // when the section is loading, display the activity indicator
            if sections.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
            } else {
                // set the cell as the Course Description Cell when this is the first section
                let cell = tableView.dequeueReusableCell(withIdentifier: "Course Description Cell", for: indexPath)
                if courseDescription == "" {
                    let noCourseDescription = NSLocalizedString("No Course Description", comment: "-No Course Description")
                    cell.textLabel?.text = noCourseDescription
                } else {
                    cell.textLabel?.text = courseDescription
                }
                return cell
            }
        } else {
            // when the section is loading, display the activity indicator
            if sections.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
            } else {
                
                // set the cell as the Section Cell when this is the second section
                let cell = tableView.dequeueReusableCell(withIdentifier: "Section Cell", for: indexPath)
                cell.textLabel?.text = sections[indexPath.row].description + " (" + sections[indexPath.row].sectionType + ")"
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            // return Course Description for the first section header
            let courseDescription = NSLocalizedString("Course Description: ", comment: "-Course Description: ")
            return courseDescription
        } else if section == 1 {
            // return Section as the header for the second section
            let section = NSLocalizedString("Section:", comment: "-Section:")
            return section
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
        // sdtc: SectionDetailTableViewController, Pass the selected object to the new view controller.
        if let sdtvc = segue.destination as? SectionDetailsTableViewController {
            
            if segue.identifier == "Select Section" {
                // set up the index for the selected section if the indentifier is Select Section
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    // set up the title of the section and gather the information of the section
                    sdtvc.title = "Section" + " " + sections[indexPath.row].description + " (" + sections[indexPath.row].sectionType + ")"
                    sdtvc.selectedSection = sections[indexPath.row]
                    sdtvc.selectedCourse = selectedCourse
                    sdtvc.selectedSubject = selectedSubject
                    sdtvc.selectedSchool = selectedSchool
                    sdtvc.selectedTerm = selectedTerm
                    
                }
            }
        }
    }
}
