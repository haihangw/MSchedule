//
//  SchoolTableViewController.swift
//  M Scheduler
//
//  Created by Hedge Wang on 11/25/15.
//  Copyright © 2015 SubWay. All rights reserved.
//

import UIKit

class SchoolTableViewController: UITableViewController {
    
    // MARK: - Model
    
    // Create the array of the school and an variable of the type term
    var schools = [School]()
    var selectedTerm: Term!

    override func viewDidLoad() {
        super.viewDidLoad()

        // hide empty cells below
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // load schools from the API to fill the school array
        CoursesAPIManager.loadSchoolsForTerm(selectedTerm!) { (schoolsFromAPI) -> Void in
            self.schools = schoolsFromAPI
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
        
        // there would be only one section contains all the schools
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // return the number of schools if this is the first section
        if section == 0 {
            return schools.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // when the section is loading, display the activity indicator
            if schools.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
                
            } else {
                
                // set the cell as the School Cell when this is the first section
                let cell = tableView.dequeueReusableCell(withIdentifier: "School Cell", for: indexPath)
                cell.textLabel?.text = schools[indexPath.row].description
                return cell
            }
        } else {
            // when the section is loading, display the activity indicator
            if schools.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "School Cell", for: indexPath)
                cell.textLabel?.text = schools[indexPath.row].description
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
        
        // subtvc: SubjectTableViewController, link to the next TableViewControler
        if let subtvc = segue.destination as? SubjectTableViewController {
            
            if segue.identifier == "Select School" {
                // if the identifier is the select school, then set up the index of the selected school
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    // set up the corresponded information of the selected school
                    subtvc.title = schools[indexPath.row].description
                    subtvc.selectedSchool = schools[indexPath.row]
                    subtvc.selectedTerm = selectedTerm
                }
            }
        }
    }
}
