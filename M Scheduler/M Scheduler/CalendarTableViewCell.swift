//
//  CalendarTableViewCell.swift
//  M Scheduler
//
//  Created by Hedge Wang on 12/7/15.
//  Copyright © 2015 SubWay. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    //var favoriteCourses = []
    //var selectedCourses = [Course]()
    var selectedSection: Section!
    var selectedCourse: Course!
    var selectedSubject: Subject!
    var selectedSchool: School!
    var selectedTerm: Term!
    
    /* A lot of the functions below are copied and modified from online sources.*/
    
    var userDefaults = UserDefaults.standard
    
    @IBAction func addButton(_ sender: UIButton) {
        let addToSchedule = NSLocalizedString("Add to Schedule", comment: "-Add to Schedule")
        let remoFromSchedule = NSLocalizedString("Remove from Schedule", comment: "-Remove from Schedule")
        if addedButton.titleLabel!.text == addToSchedule {
            addedButton.setTitle(remoFromSchedule, for: UIControlState())
        } else if addedButton.titleLabel!.text == remoFromSchedule{
            addedButton.setTitle(addToSchedule, for: UIControlState())
        }
    }
    
    @IBOutlet weak var addedButton: UIButton!
    
    
    @IBAction func favButton(_ sender: UIButton) {
        let addToFavorite = NSLocalizedString("Add to Favorite", comment: "-Add to Favorite")
        let remoFromFavorite = NSLocalizedString("Remove from Favorite", comment: "-Remove from Favorite")
        
        let favCourse: String! = selectedTerm!.description + " " + selectedSchool!.description + " " + selectedSubject!.description + " " + selectedCourse!.description + " " + selectedSection!.description
        
        if var favCourses = userDefaults.array(forKey: "Favorite") as? [String] {
            if !favCourses.contains(favCourse) {
                favCourses.append(favCourse)
                self.userDefaults.setValue(favCourses, forKey: "Favorite")
                self.userDefaults.synchronize()
                favedButton.setTitle(remoFromFavorite, for: UIControlState())
            } else {
                let index = favCourses.index(of: favCourse)
                favCourses.remove(at: index!)
                self.userDefaults.setValue(favCourses, forKey: "Favorite")
                self.userDefaults.synchronize()
                favedButton.setTitle(addToFavorite, for: UIControlState())
            }
        } else {
            var favCourses = [String]()
            favCourses.append(favCourse)
            self.userDefaults.setValue(favCourses, forKey: "Favorite")
            self.userDefaults.synchronize()
            favedButton.setTitle(remoFromFavorite, for: UIControlState())
        }
    }
    
    
    @IBOutlet weak var favedButton: UIButton!
    
    
}

