//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Polina Fiksson on 27/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
    
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var websiteTextField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.borderStyle = UITextBorderStyle.roundedRect
        websiteTextField.borderStyle = UITextBorderStyle.roundedRect
        findButton.layer.cornerRadius = 4
        findButton.clipsToBounds = true
        
        locationTextField.delegate = self
        websiteTextField.delegate = self
        
        getUserInfo()

        // Do any additional setup after loading the view.
    }
    
    //hide keyboard when user touches outside of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard when pressing the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        websiteTextField.resignFirstResponder()
        return true
    }

 
    @IBAction func findLocation(_ sender: UIButton) {
        
        if locationTextField.text!.isEmpty{
            print("no location was entered")
        }else if websiteTextField.text!.isEmpty{
            print("no website was entered")
        }else{
            Student.sharedUser().mapString = locationTextField.text!
            Student.sharedUser().mediaURL = websiteTextField.text!
            
            forwardGeocode()
            
        }
    }
    
    func forwardGeocode(){
        
        activityIndicator.center = self.view.center
        //activityIndicator.isHidden = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        
        activityIndicator.startAnimating()
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(locationTextField.text!, completionHandler: {
            placemarks, error in
            
            self.processGeoResponse(withPlacemarks: placemarks, error: error)
            
        })
        
    }
    
    private func processGeoResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        
        activityIndicator.stopAnimating()
        
        if error != nil {
            showAlert(title: "Geocoding Failed", message: "Unable to Forward Geocode the address.")
        
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                print("\(coordinate.latitude), \(coordinate.longitude)")
                
                Student.sharedUser().latitude = coordinate.latitude
                Student.sharedUser().longitude = coordinate.longitude
                
                performSegue(withIdentifier: "toMap", sender: self)
            } else {
                showAlert(title: "Location not found", message: "Location with such a name was not found.")
            }
        }
    }
    
    func getUserInfo(){
        UdacityClient.sharedInstance().getUserData { (success, errorString) in
            guard (errorString == nil) else{
                print("error!")
                return
            }
        }
    }

    @IBAction func cancelInfoPosting(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title:String, message:String?) {
        
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

}
