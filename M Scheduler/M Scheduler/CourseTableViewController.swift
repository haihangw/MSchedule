//
//  CourseTableViewController.swift
//  M Scheduler
//
//  Created by 叶亚鑫 on 15/11/25.
//  Copyright © 2015年 SubWay. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {
    
    // MARK: - Model
    
    // create and array of the type Course
    // create the variables representing the selected term, school and subject
    var courses = [Course]()
    var selectedSubject: Subject!
    var selectedTerm: Term!
    var selectedSchool: School!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide empty cells below
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // set up the size of the tableView that contains the information
        // of the selected course
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
  
        // load the course information for the selected subject from the APT
        // to fill the course array
        CoursesAPIManager.loadCoursesForSubject(selectedSubject!, andTerm: selectedTerm!, andSchool: selectedSchool!) { (coursesFromAPI) -> Void in
            self.courses = coursesFromAPI
            // reload the data from main thread
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
        
        // there would only be two sections, one is for course description
        // the other is for the list of the course lecture sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // if this is the first section, return the number of course
        // as the number of rows in this section
        if section == 0 {
            return courses.count
        } else if section == 1 {
            if courses.count == 0 {
                // return one row to indicate no course in the second section
                return 1
            } else {
                // else return the number of course as the number of rows
                // to contain the information of all the courses
                return courses.count
            }
        } else {
            // there is no other sections
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            // when the section is loading, display the activity indicator
            if courses.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
                
            } else {
            
                // set the cell as the Course Cell when this is the first section
                let cell = tableView.dequeueReusableCell(withIdentifier: "Course Cell", for: indexPath)
                cell.textLabel?.text = selectedSubject.description + " " + courses[indexPath.row].description + " - " + courses[indexPath.row].name
                return cell
                }
        } else {
            // when the section is loading, display the activity indicator
            if courses.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Course Cell", for: indexPath)
                cell.textLabel?.text = selectedSubject.description + " " + courses[indexPath.row].description + " - " + courses[indexPath.row].name
                return cell
            }
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
        
        // sectvc: SectionTableViewController, link to the next TableViewController
        if let sectvc = segue.destination as? SectionTableViewController {
            
            if segue.identifier == "Select Course" {
                // set up the index of the selected course if the indentifier is the select course
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    // set up the corresponded information of the selected course
                    // and set up the title of the course
                    sectvc.title = selectedSubject.name + " " + courses[indexPath.row].description
                    sectvc.selectedCourse = courses[indexPath.row]
                    sectvc.selectedSubject = selectedSubject
                    sectvc.selectedSchool = selectedSchool
                    sectvc.selectedTerm = selectedTerm
                }
            }
        }
    }
}
