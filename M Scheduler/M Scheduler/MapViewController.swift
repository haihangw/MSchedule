//
//  MapViewController.swift
//  M Scheduler
//
//  Created by Hedge Wang on 12/3/15.
//  Copyright © 2015 SubWay. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook
import Contacts


class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    // create the button to inplement the map location function
    @IBOutlet weak var mapView: MKMapView!
    
    // store the possible locations for the classes
    var locationDictionary: [String: String] = ["A&AB": "2281 Bonisteel Blvd, Ann Arbor", "AH": "435 S State St, Ann Arbor", "AL": "Beal Ave, Ann Arbor", "ALH": "100 Observatory St, Ann Arbor", "ANNEX": "1015 E Huron St, Ann Arbor", "ARGUS2": "408 S. Fourth Street, Ann Arbor", "ARGUS3": "416 S. Fourth Street, Ann Arbor", "ARR": "No Address", "BAM HALL": "No Address", "BELL POOL": "401 Washtenaw Ave, Ann Arbor", "BEYST": "2260 Hayward Ave, Ann Arbor", "BIOL STAT": "9133 Biological Rd, Ann Arbor", "BMT": "230 N Ingalls St, Ann Arbor", "BOT GARD": "1800 N Dixboro Rd, Ann Arbor", "BSRB": "109 Zina Pitcher Pl, Ann Arbor", "BURS": "1931 Duffield St, Ann Arbor", "BUS": "701 Tappan Ave, Ann Arbor", "CAMP DAVIS": "Camp Davis Rd, Ann Arbor", "CCL": "1100 North UNIVERSITY AVE, Ann Arbor", "CCRB": "401 Washtenaw Ave, Ann Arbor", "CHEM": "930 N University Ave, Ann Arbor", "CHRYS": "333 E Stadium Blvd, Ann Arbor", "COMM PARK": "No Address", "COOL": "2355 BONISTEEL BLVD, Ann Arbor", "COUZENS": "1300 E Ann St, Ann Arbor", "CPH": "1540 E Hospital Dr, Ann Arbor", "CRISLER": "333 E Stadium Blvd, Ann Arbor", "CCSB": "1239 Kipke Dr, Ann Arbor", "DANA": "440 Church St, Ann Arbor", "DANCE": "1310 N University Court, Ann Arbor", "DC": "2281 Bonisteel Blvd, Ann Arbor", "DENN": "500 Church Street, Ann Arbor", "DENT": "1011 N University Ave, Ann Arbor", "DOW": "1221 Beal Ave, Ann Arbor", "E-BUS": "701 Tappan Ave, Ann Arbor", "EECS": "1301 Beal Ave, Ann Arbor", "EH": "530 Church St, Ann Arbor", "EQ": "701 E University Ave, Ann Arbor", "ERB1": "2200 Bonisteel Blvd, Ann Arbor", "ERB2": "No Address", "EWRE": "1351 Beal Ave, Ann Arbor", "FA CAMP": "No Address", "FORD LIB": "2393–2453 Fuller Rd, Ann Arbor", "FXB": "1320 Beal Ave, Ann Arbor", "GFL": "2609 Draper Dr, Ann Arbor", "GGBL": "2350 Hayward Ave, Ann Arbor", "GLIBN": "913 S University Ave, Ann Arbor", "HH": "505 S State St, Ann Arbor", "HUTCH": "625 S State St, Ann Arbor", "IM POOL": "606 E Hoover Ave", "IOE": "1205 Beal Ave, Ann Arbor", "ISR": "426 Thompson St, Ann Arbor", "K-BUS": "703 Tappan St, Ann Arbor", "KEC": "1000 Wall St", "KEENE THTR EQ": "No Address", "KELSEY": "434 S State St, Ann Arbor", "KHRI": "No Address", "LANE": "204 S State St, Ann Arbor", "LBME": "1101 Beal Ave, Ann Arbor", "LEAG": "911 N University Ave, Ann Arbor", "LEC": "1221 Beal Ave, Ann Arbor", "LLIB": "801 Monroe St", "LORCH": "611 Tappan St, Ann Arbor", "LSA": "500 S State St, Ann Arbor", "LSI": "210 Washtenaw Ave, Ann Arbor", "LSSH": "625 S State St, Ann Arbor", "MARKLEY": "1503 Washington Hts, Ann Arbor", "MAX KADE": "627 Oxford St, Ann Arbor", "MH": "419 S State St, Ann Arbor", "MHRI": "205 Zina Pitcher Pl", "MLB": "812 E Washington St, Ann Arbor", "MONREOCTY HD": "2353 S Custer Rd", "MOSHER": "200 Observatory St", "MOTT": "1540 E Medical Center Dr", "MSC1": "No Address", "MSC2": "No Address", "MSRB3": "No Address", "NAME": "2600 Draper Drive, Ann Arbor", "NCRB": "2375 Hubbard Rd", "NCRC": "2800 Plymouth Rd, Ann Arbor", "NIB": "300 N Ingalls St", "400NI": "400 N Ingalls St", "NORTHVILLEPH": "State Hospital, Pontiac, MI 48341", "NQ": "105 S State St, Ann Arbor", "NS": "830 N University Ave, Ann Arbor", "OBL": "1402 Washington Hts, Ann Arbor", "PALM": "100 Washtenaw Ave, Ann Arbor", "PHOENIXLAB": "2301 Bonisteel Blvd, Ann Arbor", "PIER": "2101 Bonisteel Blvd, Ann Arbor", "POWER CTR": "121 Fletcher St", "RACK": "915 E Washington St, Ann Arbor", "RAND": "450 Church St, Ann Arbor", "R-BUS": "701 Tappan St, Ann Arbor", "REVELLI": "1100 Baits Dr", "ROSS AC": "1110 S State St, Ann Arbor", "RUTHVEN": "1109 Geddes Ave, Ann Arbor", "SCHEM": "1200 S State St, Ann Arbor", "SEB": "610 E University Ave, Ann Arbor", "SHAPIRO": "919 S University Ave, Ann Arbor", "SM": "1100 Baits Dr", "SNB": "400 N Ingalls St", "SPH1": "1415 Washington Hts", "SPH2": "1420 Washington Hts, Ann Arbor", "SRB": "Space Research Ctr, Ann Arbor", "SSWB": "1080 S University Ave, Ann Arbor", "STAMPS": "1226 Murfin Ave", "STB": "202 S Thayer St, Ann Arbor", "STJOSEPH HOSP": "5301 McAuley Dr Ypsilanti", "STOCKWELL": "324 Observatory St", "STRNS": "Stearns Bldg", "T&TB": "No Address", "TAP": "Tappan St, Ann Arbor", "TAUBL": "1135 Catherine St, Ann Arbor", "TISCH": "505 S State St, Ann Arbor", "UM HOSP": "1500 E Medical Center Dr", "UMMA": "525 S State St, Ann Arbor", "UNION": "530 S State St, Ann Arbor", "USB": "204 Washtenaw Ave, Ann Arbor", "UTOWER": "1225 S University Ave, Ann Arbor", "VETERANSHOSP": "2215 Fuller Rd", "WASHCTY HD": "555 Towner St #1", "W-BUS": "770-, 798 E University Ave, Ann Arbor", "WDC": "1226 Murfin Ave", "WEILL": "735 S STate St, Ann Arbor", "WEIS": "500 Church St, Ann Arbor", "WH": "1085 S University Ave, Ann Arbor", "WOMEN'S HOSP": "1540 E Hospital Dr", "WQ": "541 Thompson St, Ann Arbor"]

    var meetingLocation: String!
    
    
    let regionRadius: CLLocationDistance = 1000
    
    /* A lot of the functions below are copied and modified from online sources.*/
    
    // this function will center the map
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - location manager to authorize user location for Maps app
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var address = ""
        if meetingLocation != nil {
            address = meetingLocation
        }
        var addressFull = ""
        
        
        // not all locations in the dictionary can be treated using spliting and getting the last string
        
        if meetingLocation == "BAM HALL" || meetingLocation == "BELL POOL" || meetingLocation == "FORD LIB" || meetingLocation == "WOMEN'S HOSP" || meetingLocation == "UM HOSP" || meetingLocation == "STJOSEPH HOSP" || meetingLocation == "ROSS AC" || meetingLocation == "POWER CTR" || meetingLocation == "STATE HOSPITAL" || meetingLocation == "MONREOCTY HD" || meetingLocation == "MAX KADE" || meetingLocation == "KEENE THTR EQ" || meetingLocation == "FA CAMP" || meetingLocation == "BIOL STAT" || meetingLocation == "BOT GARD" || meetingLocation == "CAMP DAVIS" || meetingLocation == "COMM PARK" {
            addressFull = locationDictionary[meetingLocation]!
        } else {
            let addressArr = address.components(separatedBy: " ")
            let addressLast = addressArr.last
            addressFull = locationDictionary[addressLast!]!
        }
        
        print(addressFull)

        var placemark: CLPlacemark!
        let geocoder = CLGeocoder()
        let annotation = MKPointAnnotation()
        // var view = MKPinAnnotationView()
        geocoder.geocodeAddressString(addressFull, completionHandler: {
            (placemarks, error) -> Void in
            
            
            if error == nil {
                placemark = placemarks![0] as CLPlacemark
                let lat = placemark.location?.coordinate.latitude
                let long = placemark.location?.coordinate.longitude
                
                self.mapView.delegate = self
                
                let meetingLoc = Meeting2(title: self.meetingLocation, locationName: addressFull, discipline: "", coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: long!))
                
                self.mapView.addAnnotation(meetingLoc)
                self.centerMapOnLocation(CLLocation(latitude: lat!, longitude: long!))
            } else {
                placemark = placemarks![0] as CLPlacemark
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: 42.277162, longitude: -83.738183)
                annotation.title = self.meetingLocation
                let locationNotFound = NSLocalizedString("Location Not Found", comment: "-Location Not Found")
                annotation.subtitle = locationNotFound
            }
        })
        
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // we only want to use the location services when we are using the app, now when the app is in the background
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    // Mark: - Location Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: " + error.localizedDescription)
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
