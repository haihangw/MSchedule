//
//  SubjectTableViewController.swift
//  M Scheduler
//
//  Created by Hedge Wang on 11/25/15.
//  Copyright © 2015 SubWay. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController {

    
    // MARK: - Model
    
    // Create the array of the type subject and set up two variables 
    // representing the selected school and term
    var subjects = [Subject]()
    var selectedSchool: School!
    var selectedTerm: Term!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide empty cells below
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // load the subjects for the selected school from the API to fill the subject array
        CoursesAPIManager.loadSubjectsForSchool(selectedSchool!, andTerm: selectedTerm!) { (subjectsFromAPI) -> Void in
            self.subjects = subjectsFromAPI
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
        
        // there would be only one section contains all the subjects
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // return the number of the subjects if this is the first section
        if section == 0 {
            return subjects.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        // when the section is loading, display the activity indicator
            if subjects.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
            
            } else {
            
                // set the cell as the Subject Cell when this is the first section
                let cell = tableView.dequeueReusableCell(withIdentifier: "Subject Cell", for: indexPath)
                cell.textLabel?.text = subjects[indexPath.row].description
                return cell
            }
        } else {
            // when the section is loading, display the activity indicator
            if subjects.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Subject Cell", for: indexPath)
                cell.textLabel?.text = subjects[indexPath.row].description
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
        
        // ctvc: CourseTableViewController, link to the next TableViewController
        if let ctvc = segue.destination as? CourseTableViewController {
            if segue.identifier == "Select Subject" {
                // set up the index of the selected subject if the identifier is the select subject
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    // set up the information of the selected subject and its title
                    ctvc.title = subjects[indexPath.row].description
                    ctvc.selectedSubject = subjects[indexPath.row]
                    ctvc.selectedSchool = selectedSchool
                    ctvc.selectedTerm = selectedTerm
                }
            }
        }
    }
}
