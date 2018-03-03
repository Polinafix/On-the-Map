//
//  TabBarViewController.swift
//  On The Map
//
//  Created by Polina Fiksson on 05/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        UdacityClient.sharedInstance().logout { (success, errorString) in
        
            if success{
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                print(errorString!)
            }
        }
    }
   
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        let controller = self.viewControllers![0] as! MapViewController
        controller.getStudentLocations()
    }

    

}
