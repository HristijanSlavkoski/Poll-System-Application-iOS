//
//  MapViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/29/22.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var pollId: String?
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var firebaseAuth: Auth!
    var firebaseUser: FirebaseAuth.User!
    var firebaseDatabase: Database!
    var databaseReference: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseAuth = Auth.auth()
        firebaseUser = firebaseAuth.currentUser
        firebaseDatabase = Database.database()
        databaseReference = firebaseDatabase.reference()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        
        //KIKO SEGA OVDE DA ZEMIME LOKACII
        databaseReference.child("vote").child(pollId!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() && snapshot.hasChildren() {
                for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    if let locationData = (dataSnapshot.value as! NSDictionary).value(forKey: "location") as? [String: Double] {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: locationData["latitude"]!, longitude: locationData["longitude"]!)
                        print(locationData["latitude"]!)
                        print("HH")
                        print(locationData["longitude"]!)
                        //USER TREBA OVDE
                        annotation.title = dataSnapshot.key as? String
                        self.map.addAnnotation(annotation)
                    } else {
                        print("No value for 'location' key")
                    }
                }
            } else {
                print("Snapshot is empty or does not exist")
            }
        })
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.markerTintColor = UIColor.red
        
        return annotationView
    }
}
