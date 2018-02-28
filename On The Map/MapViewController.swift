//
//  MapViewController.swift
//  On The Map
//
//  Created by Polina Fiksson on 25/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        getStudentLocations()
        
    }
    
    func getStudentLocations(){
        
        ParseClient.sharedInstance().getStudentLocation { (studentsResult, error) in
            performUIUpdatesOnMain {
            if let students = studentsResult{
                Student.sharedUser().studentLocations = students
                self.addAnnotations()
                
            }else{
                self.showAlert(title: "Download Failed", message: "Unable to download students' locations.")
  
                }
            }
        }
    }
    
    func addAnnotations(){
        var annotations = [MKPointAnnotation]()
        
        for student in Student.sharedUser().studentLocations{
            
            if let latitude = student.latitude,let longitude = student.longitude,let first = student.firstName, let last = student.lastName, let mediaURL = student.mediaURL {
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                annotations.append(annotation)
            }
            
        }
        
        self.mapView.addAnnotations(annotations)
        print("annotations added to the map view.")
    }
    
   
    @IBAction func unwindToMap(segue:UIStoryboardSegue) { }
    
    func showAlert(title:String, message:String?) {
        
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }


}
extension MapViewController:MKMapViewDelegate {
    
    //mapView(_:viewFor:) gets called for every annotation you add to the map to return the view for each annotation.
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        // map view reuses annotation views that are no longer visible. So you check to see if a reusable annotation view is available before creating a new one
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        //Here you create a new MKPinAnnotationView object, if an annotation view could not be dequeued.
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
 
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
