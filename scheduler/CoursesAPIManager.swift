//
//  CoursesAPIManager.swift
//  Scheduler
//
//  Created by Maxim Aleksa on 11/3/15.
//  Copyright © 2015 Maxim Aleksa. All rights reserved.
//

import Foundation

class CoursesAPIManager {
    
    private struct Constants {
        
        static let baseURL = "https://umich-schedule-api.herokuapp.com/v2/"
    }
    
    
    private class func loadDataArrayForURL<T: JSONInitializable>(url: String, completionHandler: (result: [T]) -> Void) {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            if data != nil {
                
                var result = [T]()
                
                do {
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    if let schoolsArray = jsonArray as? [NSDictionary] {
                        for item in schoolsArray {
                            let newItem = T(json: item)
                            result.append(newItem)
                        }
                    }
                    
                    completionHandler(result: result)
                } catch _ {
                    // error
                    completionHandler(result: [])
                }
            }
        }
        task.resume()
    }
    
    
    class func getTerms() -> [Term] {
        
        // recent terms
        let terms = [Term(code: 2010, year: 2014, semester: "Fall"),
                    Term(code: 2020, year: 2015, semester: "Winter"),
                    Term(code: 2030, year: 2015, semester: "Spring"),
                    Term(code: 2040, year: 2015, semester: "Summer"),
                    Term(code: 2050, year: 2015, semester: "Spring/Summer"),
                    Term(code: 2060, year: 2015, semester: "Fall"),
                    Term(code: 2070, year: 2016, semester: "Winter"),
                    Term(code: 2080, year: 2016, semester: "Spring"),
                    Term(code: 2090, year: 2016, semester: "Summer"),
                    Term(code: 2100, year: 2016, semester: "Spring/Summer")]
        
        return terms
    }
    
    class func loadTerms(completionHandler: (terms: [Term]) -> Void) {
        
        completionHandler(terms: getTerms())
    }
    
    
    class func loadSchoolsForTerm(term: Term, completionHandler: (schools: [School]) -> Void) {
        
        let url = Constants.baseURL + "get_schools?term_code=\(term.code)"
        loadDataArrayForURL(url, completionHandler: completionHandler)
    }
    
    class func loadSubjectsForSchool(school: School, andTerm term: Term, completionHandler: (subjects: [Subject]) -> Void) {
        
        let url = Constants.baseURL + "get_subjects?term_code=\(term.code)&school=\(school.code)"
        loadDataArrayForURL(url, completionHandler: completionHandler)
    }
    
    class func loadCoursesForSubject(subject: Subject, andTerm term: Term, andSchool school: School, completionHandler: (courses: [Course]) -> Void) {
        
        let url = Constants.baseURL + "get_catalog_numbers?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)"
        loadDataArrayForURL(url, completionHandler: completionHandler)
    }
    

    class func loadCourseDescriptionForCourse(course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: (courseDescription: String) -> Void) {
        
        let url = Constants.baseURL + "get_course_description?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)"
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            if data != nil {
                
                if let stringFromAPI = String(data: data!, encoding: NSUTF8StringEncoding) {
                    
                    completionHandler(courseDescription: String(stringFromAPI.characters.dropFirst().dropLast()))
                } else {
                    completionHandler(courseDescription: "Course description not available.")
                }

            }
        }
        task.resume()
    }
    
    class func loadSectionsNumbersForCourse(course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: (sectionNumbers: [String]) -> Void) {
        
        let url = Constants.baseURL + "get_section_nums?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)"
        
        print(url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            if data != nil {
                
                var result = [String]()
                
                do {
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    if let sectionsArray = jsonArray as? [String] {
                        for sectionNumber in sectionsArray {
                            result.append(sectionNumber)
                        }
                    } else if let sectionsArray = jsonArray as? [Int] {
                        for sectionNumber in sectionsArray {
                            result.append("\(sectionNumber)")
                        }
                    } else if let anyArray = jsonArray as? [AnyObject] {
                        for sectionNumber in anyArray {
                            if let sectionAsInt = sectionNumber as? Int {
                                result.append("\(sectionAsInt)")
                            } else if let sectionAsString = sectionNumber as? String {
                                result.append(sectionAsString)
                            }
                            
                            
                        }
                    }
                    
                    completionHandler(sectionNumbers: result)
                } catch _ {
                    // error
                    completionHandler(sectionNumbers: [])
                }
            }
        }
        task.resume()
    }
    
    
    class func loadSectionDetailsForSectionNumber(sectionNumber: String, andCourse course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: (section: Section?) -> Void) {
        
        let url = Constants.baseURL + "get_section_details?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)&section_num=\(sectionNumber)"
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            if data != nil {
                
                do {
                    if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        
                        let result = Section(json: jsonDictionary, sectionNumber: sectionNumber)
                        
                        completionHandler(section: result)
                    }
                } catch _ {
                    // error
                    completionHandler(section: nil)
                }
            }
        }
        task.resume()
    }
    

    class func loadSectionsForCourse(course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: (sections: [Section]) -> Void) {
        
        loadSectionsNumbersForCourse(course, andSubject: subject, andSchool: school, andTerm: term) { (sectionNumbers) -> Void in
            
            var sections = [Section]()
            
            for sectionNumber in sectionNumbers {
                
                loadSectionDetailsForSectionNumber(sectionNumber, andCourse: course, andSubject: subject, andSchool: school, andTerm: term, completionHandler: { (section) -> Void in
                    
                    sections.append(section!)
                    
                    if sections.count == sectionNumbers.count {
                        completionHandler(sections: sections)
                    }
                })
            }
        }
    }

    
    class func loadInstructorsForSectionNumber(sectionNumber: String, andCourse course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: (instructors: [Instructor]) -> Void) {
        
        let url = Constants.baseURL + "get_instructors?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)&section_num=\(sectionNumber)"
        
        loadDataArrayForURL(url, completionHandler: completionHandler)
    }
    
    
    class func loadTextbooksForSectionNumber(sectionNumber: String, andCourse course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: (textbooks: [Textbook]) -> Void) {
        
        let url = Constants.baseURL + "get_textbooks?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)&section_num=\(sectionNumber)"
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            if data != nil {
                
                do {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    
                    var result = [Textbook]()
                    
                    if let textbookData = jsonData as? NSDictionary {
                        
                        if let jsonArray = textbookData["Textbook"] as? [NSDictionary] {
                            for element in jsonArray {
                                result.append(Textbook(json: element))
                            }
                        } else if let jsonDictionary = textbookData["Textbook"] as? NSDictionary {
                            result.append(Textbook(json: jsonDictionary))
                        }
                    }
                    
                    completionHandler(textbooks: result)
                } catch _ {
                    // error
                    completionHandler(textbooks: [])
                }
            }
        }
        task.resume()
    }
    
    class func loadMeetingsForSectionNumber(sectionNumber: String, andCourse course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: (meetings: [Meeting]) -> Void) {
        
        let url = Constants.baseURL + "get_meetings?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)&section_num=\(sectionNumber)"
        
        loadDataArrayForURL(url, completionHandler: completionHandler)
    }
}

protocol JSONInitializable {
    init(json: NSDictionary)
}