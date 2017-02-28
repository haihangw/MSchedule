//
//  RandomViewController.swift
//  M Scheduler
//
//  Created by Hedge Wang on 12/12/15.
//  Copyright © 2015 SubWay. All rights reserved.
//

import UIKit

let falla = NSLocalizedString("Fall 2015", comment: "-Fall 2015")
let wintera = NSLocalizedString("Winter 2016", comment: "-Winter 2016")
let springa = NSLocalizedString("Spring 2016", comment: "-Spring 2016")
let summera = NSLocalizedString("Summer 2016", comment: "-Summer 2016")
let spsua = NSLocalizedString("Spring/Summer 2016", comment: "-Spring/Summer 2016")

class RandomViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    /* A lot of the functions below are copied and modified from online sources.*/
    
    // create the button to pick the recommendation class
    @IBOutlet weak var pickTermPicker: UIPickerView!
    
    // create the outlet to display prompt
    @IBOutlet weak var promptLabel: UILabel!
    
    // create the button to submit the class chosed to be recommended
    @IBOutlet weak var submitButton: UIButton!
    
    // create the outlet to display the recommendation class
    @IBOutlet weak var randomCourseLabel: UILabel!
    
    // create variables to be used to display as recommendations
    var termsDescr = [falla, wintera, springa, summera, spsua]
    var selectedTerm: Term! = Term(code: 2060, year: 2015, semester: "Fall")
    var placementAnswer = 0
    var schools = [School]()
    var selectedSchool: School!
    var subjects = [Subject]()
    var selectedSubject: Subject!
    var courses = [Course]()
    var selectedCourse: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "🎲"
        // pick the term where the recommendation should be generated
        pickTermPicker.delegate = self
        pickTermPicker.dataSource = self
        
        // determine the prompt
        let selectATerm = NSLocalizedString("Select a Term, Then Click 🎲 Below", comment: "-Select a Term, Then Click 🎲 Below")
        promptLabel.text = selectATerm
        
        // determing the content of the button
        submitButton.setTitle("🎲", for: UIControlState())
        let toBeDecided = NSLocalizedString("To be decided!", comment: "-To be decided!")
        randomCourseLabel.text = toBeDecided
        
        /*CoursesAPIManager.loadSchoolsForTerm(selectedTerm!) { (allSchools) -> Void in
            self.schools = allSchools
            repeat {
                self.selectedSchool = self.schools.randomItem()
            } while self.selectedSchool == nil
            CoursesAPIManager.loadSubjectsForSchool(self.selectedSchool!, andTerm: self.selectedTerm!, completionHandler: { (allSubjects) -> Void in
                self.subjects = allSubjects
                repeat {
                    self.selectedSubject = self.subjects.randomItem()
                } while self.selectedSubject == nil
                CoursesAPIManager.loadCoursesForSubject(self.selectedSubject!, andTerm: self.selectedTerm!, andSchool: self.selectedSchool!, completionHandler: { (allCourses) -> Void in
                    self.courses = allCourses
                    repeat {
                        self.selectedCourse = self.courses.randomItem()
                    } while self.selectedCourse == nil
                })
            })
        }*/

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIPickerDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // return the term information for the chosed term
        return termsDescr[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        // there is only one line of the recommendation
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // return the number of the terms
        return termsDescr.count
    }
    
    @IBAction func submittedButton(_ sender: UIButton) {
        
        // create the identifiers of the terms
        let fall = NSLocalizedString("Fall", comment: "-Fall")
        let winter = NSLocalizedString("Winter", comment: "-Winter")
        let spring = NSLocalizedString("Spring", comment: "-Spring")
        let summer = NSLocalizedString("Summer", comment: "-Summer")
        let springsummer = NSLocalizedString("Spring/Summer", comment: "-Spring/Summer")
        
        // identify the terms where the course should be choosen from
        if placementAnswer == 0 {
            selectedTerm = Term(code: 2060, year: 2015, semester: fall)
        } else if placementAnswer == 1 {
            selectedTerm = Term(code: 2070, year: 2016, semester: winter)
        } else if placementAnswer == 2 {
            selectedTerm = Term(code: 2080, year: 2016, semester: spring)
        } else if placementAnswer == 3 {
            selectedTerm = Term(code: 2090, year: 2016, semester: summer)
        } else {
            selectedTerm = Term(code: 2100, year: 2016, semester: springsummer)
        }
        
        // load course from API
        CoursesAPIManager.loadSchoolsForTerm(selectedTerm!) { (allSchools) -> Void in
            self.schools = allSchools
            repeat {
                self.selectedSchool = self.schools.randomItem()
            } while self.selectedSchool == nil
            CoursesAPIManager.loadSubjectsForSchool(self.selectedSchool!, andTerm: self.selectedTerm!, completionHandler: { (allSubjects) -> Void in
                self.subjects = allSubjects
                repeat {
                    self.selectedSubject = self.subjects.randomItem()
                } while self.selectedSubject == nil
                CoursesAPIManager.loadCoursesForSubject(self.selectedSubject!, andTerm: self.selectedTerm!, andSchool: self.selectedSchool!, completionHandler: { (allCourses) -> Void in
                    self.courses = allCourses
                    self.selectedCourse = self.courses.randomItem()
                })
            })
        }
        
        // create the string as the message to be displayed
        var displayMessage = ""
        if selectedCourse == nil {
            
            // display the message if no course is generated
            let tryAgain = NSLocalizedString("Try Again! Better Luck Next Time!", comment: "-Try Again! Better Luck Next Time!")
            displayMessage = tryAgain
        } else {
            
            // display the course if the recommendation is successfully generated
            displayMessage = selectedTerm!.description + " " + selectedSchool!.description + " " +
                selectedSubject!.description + " " + selectedCourse!.description
        }
        randomCourseLabel.text = displayMessage
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // return corresponding row of the recommendation
        placementAnswer = row
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
