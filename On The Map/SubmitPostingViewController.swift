//
//  SubmitPostingViewController.swift
//  On The Map
//
//  Created by Polina Fiksson on 29/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit
import MapKit

class SubmitPostingViewController: UIViewController {
    
    @IBOutlet weak var bigMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateMapView()

    }

    private func populateMapView(){
        
        var annotations = [MKPointAnnotation]()
        //create a coordinate for the current student's location
        let lat = CLLocationDegrees(Student.sharedUser().latitude!)
        let lon = CLLocationDegrees(Student.sharedUser().longitude!)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        //create a new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(String(describing: Student.sharedUser().firstName)) \(String(describing: Student.sharedUser().lastName))"
        annotation.subtitle = Student.sharedUser().mediaURL
        annotations.append(annotation)
        
        //zoom into an appropriate region
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
        
        performUIUpdatesOnMain {
            self.bigMap.addAnnotations(annotations)
            self.bigMap.setRegion(region, animated: true)
            //print("new location added to the map view.")
        }
      
    }
    
    @IBAction func confirmSubmit(_ sender: UIButton) {
        
        ParseClient.sharedInstance().postStudentLocation { (results, error) in
            
            guard (error == nil) else {
                performUIUpdatesOnMain {
                    self.showAlert(title: "Submission failed", message: "Submission failed to post the data to the server.")
                }
                return
            }
            
            if let objectId = results{
                Student.sharedUser().objectId = objectId
                self.showMain()
            }
            
            
        }
    }
    
    func showAlert(title:String, message:String?) {
        
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func showMain(){
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: "Success!", message: "Your new location has been added!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action) -> Void in
                self.performSegue(withIdentifier: "unwindToMap", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelSubmit(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToMap", sender: self)
    }

}
