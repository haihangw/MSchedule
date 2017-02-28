//
//  CoursesAPIManager.swift
//  Scheduler
//
//  Created by Maxim Aleksa on 11/3/15.
//  Copyright © 2015 Maxim Aleksa. All rights reserved.
//

import Foundation

class CoursesAPIManager {
    
    fileprivate struct Constants {
        
        static let baseURL = "https://umich-schedule-api.herokuapp.com/v2/"
    }
    
    
    fileprivate class func loadDataArrayForURL<T: JSONInitializable>(_ url: String, completionHandler: @escaping (_ result: [T]) -> Void) {
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            if data != nil {
                
                var result = [T]()
                
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    if let schoolsArray = jsonArray as? [NSDictionary] {
                        for item in schoolsArray {
                            let newItem = T(json: item)
                            result.append(newItem)
                        }
                    }
                    
                    completionHandler(result)
                } catch _ {
                    // error
                    completionHandler([])
                }
            }
        }) 
        task.resume()
    }
    
    
    class func getTerms() -> [Term] {
        
        // recent terms
        let spring = NSLocalizedString("Spring", comment: "-Spring")
        let summer = NSLocalizedString("Summer", comment: "-Summer")
        let fall = NSLocalizedString("Fall", comment: "-Fall")
        let winter = NSLocalizedString("Winter", comment: "-Winter")
        let springSummer = NSLocalizedString("Spring/Summer", comment: "Spring/Summer")
        let terms = [Term(code: 2010, year: 2014, semester: fall),
            Term(code: 2020, year: 2015, semester: winter),
            Term(code: 2030, year: 2015, semester: spring),
            Term(code: 2040, year: 2015, semester: summer),
            Term(code: 2050, year: 2015, semester: springSummer),
            Term(code: 2060, year: 2015, semester: fall),
            Term(code: 2070, year: 2016, semester: winter),
            Term(code: 2080, year: 2016, semester: spring),
            Term(code: 2090, year: 2016, semester: summer),
            Term(code: 2100, year: 2016, semester: springSummer),
            Term(code: 2110, year: 2016, semester: fall)]
        
        return terms
    }
    
    class func loadTerms(_ completionHandler: (_ terms: [Term]) -> Void) {
        
        completionHandler(getTerms())
    }
    
    
    class func loadSchoolsForTerm(_ term: Term, completionHandler: @escaping (_ schools: [School]) -> Void) {
        
        let url = Constants.baseURL + "get_schools?term_code=\(term.code)"
        loadDataArrayForURL(url, completionHandler: completionHandler)
    }
    
    class func loadSubjectsForSchool(_ school: School, andTerm term: Term, completionHandler: @escaping (_ subjects: [Subject]) -> Void) {
        
        let url = Constants.baseURL + "get_subjects?term_code=\(term.code)&school=\(school.code)"
        loadDataArrayForURL(url, completionHandler: completionHandler)
    }
    
    class func loadCoursesForSubject(_ subject: Subject, andTerm term: Term, andSchool school: School, completionHandler: @escaping (_ courses: [Course]) -> Void) {
        
        let url = Constants.baseURL + "get_catalog_numbers?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)"
        loadDataArrayForURL(url, completionHandler: completionHandler)
    }
    
    
    class func loadCourseDescriptionForCourse(_ course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: @escaping (_ courseDescription: String) -> Void) {
        
        let url = Constants.baseURL + "get_course_description?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)"
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            if data != nil {
                
                if let stringFromAPI = String(data: data!, encoding: String.Encoding.utf8) {
                    
                    completionHandler(String(stringFromAPI.characters.dropFirst().dropLast()))
                } else {
                    let courseDescroptionNotAvailable = NSLocalizedString("Course description not available.", comment: "-Course description not available.")
                    completionHandler(courseDescroptionNotAvailable)
                }
                
            }
        }) 
        task.resume()
    }
    
    class func loadSectionsNumbersForCourse(_ course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: @escaping (_ sectionNumbers: [String]) -> Void) {
        
        let url = Constants.baseURL + "get_section_nums?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)"
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            if data != nil {
                
                var result = [String]()
                
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
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
                    
                    completionHandler(result)
                } catch _ {
                    // error
                    completionHandler([])
                }
            }
        }) 
        task.resume()
    }
    
    
    class func loadSectionDetailsForSectionNumber(_ sectionNumber: String, andCourse course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: @escaping (_ section: Section?) -> Void) {
        
        let url = Constants.baseURL + "get_section_details?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)&section_num=\(sectionNumber)"
        print(url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            if data != nil {
                
                do {
                    if let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        let result = Section(json: jsonDictionary, sectionNumber: sectionNumber)
                        
                        completionHandler(result)
                    }
                } catch _ {
                    // error
                    completionHandler(nil)
                }
            }
        }) 
        task.resume()
    }
    
    
    class func loadSectionsForCourse(_ course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: @escaping (_ sections: [Section]) -> Void) {
        
        loadSectionsNumbersForCourse(course, andSubject: subject, andSchool: school, andTerm: term) { (sectionNumbers) -> Void in
            
            var sections = [Section]()
            
            for sectionNumber in sectionNumbers {
                
                loadSectionDetailsForSectionNumber(sectionNumber, andCourse: course, andSubject: subject, andSchool: school, andTerm: term, completionHandler: { (section) -> Void in
                    
                    sections.append(section!)
                    
                    if sections.count == sectionNumbers.count {
                        completionHandler(sections)
                    }
                })
            }
        }
    }
    
    
    class func loadInstructorsForSectionNumber(_ sectionNumber: String, andCourse course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: @escaping (_ instructors: [Instructor]) -> Void) {
        
        let url = Constants.baseURL + "get_instructors?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)&section_num=\(sectionNumber)"
        
        loadDataArrayForURL(url, completionHandler: completionHandler)
    }
    
    
    class func loadTextbooksForSectionNumber(_ sectionNumber: String, andCourse course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: @escaping (_ textbooks: [Textbook]) -> Void) {
        
        let url = Constants.baseURL + "get_textbooks?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)&section_num=\(sectionNumber)"
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            if data != nil {
                
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
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
                    
                    completionHandler(result)
                } catch _ {
                    // error
                    completionHandler([])
                }
            }
        }) 
        task.resume()
    }
    
    class func loadMeetingsForSectionNumber(_ sectionNumber: String, andCourse course: Course, andSubject subject: Subject, andSchool school: School, andTerm term: Term, completionHandler: @escaping (_ meetings: [Meeting]) -> Void) {
        
        let url = Constants.baseURL + "get_meetings?term_code=\(term.code)&school=\(school.code)&subject=\(subject.code)&catalog_num=\(course.catalogNumber)&section_num=\(sectionNumber)"
        
        loadDataArrayForURL(url, completionHandler: completionHandler)
    }
}

protocol JSONInitializable {
    init(json: NSDictionary)
}
