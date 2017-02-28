//
//  Meeting2.swift
//  M Scheduler
//
//  Created by Hedge Wang on 12/7/15.
//  Copyright © 2015 SubWay. All rights reserved.
//

import Foundation
import MapKit
import AddressBook
import Contacts

/* this is the class meeting2, which is a subclass of MKAnnotation */

class Meeting2: NSObject, MKAnnotation {
    var title: String?
    var locationName: String
    var discipline: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): subtitle as AnyObject]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }

    
}
