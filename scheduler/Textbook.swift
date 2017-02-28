//
//  Textbook.swift
//  Scheduler
//
//  Created by Maxim Aleksa on 11/18/15.
//  Copyright © 2015 Maxim Aleksa. All rights reserved.
//

import Foundation

class Textbook: CustomStringConvertible, JSONInitializable {
    
    let ISBN: String
    let title: String
    let edition: String
    let requirementStatus: String
    let publicationLocation: String
    let author: String
    let publicationYear: Int
    let itemType: String
    let publisher: String
    
    var description: String {
        get {
            return title
        }
    }
    
    required init(json: NSDictionary) {
        
        if let intISBN = json["ISBN"] as? Int {
            self.ISBN = "\(intISBN)"
        } else if let stringISBN = json["ISBN"] as? String {
            self.ISBN = stringISBN
        } else {
            self.ISBN = "?"
        }
        
        self.title = json["Title"] as? String ?? "?"
        self.edition = json["Edition"] as? String ?? "?"
        self.requirementStatus = json["RequirementStatus"] as? String ?? "?"
        self.publicationLocation = json["PubLocation"] as? String ?? "?"
        self.author = json["Author"] as? String ?? "?"
        self.publicationYear = json["PubYear"] as? Int ?? 0
        self.itemType = json["ItemType"] as? String ?? "?"
        self.publisher = json["Publisher"] as? String ?? "?"
    }
}

