//
//  TermTableViewController.swift
//  M Scheduler
//
//  Created by Hedge Wang on 11/25/15.
//  Copyright © 2015 SubWay. All rights reserved.
//

import UIKit


class TermTableViewController:
    UITableViewController {
    
    // Model: - Model
    
    // Create an array of type term
    var terms = [Term]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide empty cells below
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // load terms from API to fill the terms array
        CoursesAPIManager.loadTerms { (allTerms) -> Void in
            self.terms = allTerms
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
        
        // there will only be one section that contains all the terms
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // when section eqauls to 0, returns the number of terms in the terms array
        if section == 0 {
            return terms.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // when the section is loading, display the activity indicator
            if terms.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
            
            // when the section contains more than zero terms, display all the terms
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Term Cell", for: indexPath)
                cell.textLabel?.text = terms[indexPath.row].description
                return cell
            }
        } else {
            // when the section is loading, display the activity indicator
            if terms.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loading Cell", for: indexPath)
                return cell
            
            // when the section contains more than zero terms, display all the terms
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Term Cell", for: indexPath)
                cell.textLabel?.text = terms[indexPath.row].description
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
        
        // stvc: SchoolTableViewController, link to the next table view controller
        if let stvc = segue.destination as? SchoolTableViewController {
            
            // check whether the identifer of the segue is the select term
            
            if segue.identifier == "Select Term" {
                // set up the index of the selection of the term
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    // set up the title of the term and let the 
                    // SchoolTableViewController enter the selected term
                    stvc.title = terms[indexPath.row].description
                    stvc.selectedTerm = terms[indexPath.row]
                }
            }
        }
        if let fctvc = segue.destination as? FavoriteClassTableViewController {
            if segue.identifier == "fav1" {
                // set up the index for the selected section if the indentifier is Select Section
                
                // set up the title of the section and gather the information of the section
                fctvc.title = "My Favorite"
            }
        }
    }
}
