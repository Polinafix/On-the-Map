//
//  ListsTableViewController.swift
//  On The Map
//
//  Created by Polina Fiksson on 27/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get cell type
        let cellReuseIdentifier = "ListTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let student = Student.sharedUser().studentLocations[indexPath.row]
        if let firstName = student.firstName, let lastName = student.lastName{
           cell?.textLabel!.text = firstName + " " + lastName
        }
        
        cell?.imageView!.image = UIImage(named: "icon_pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Student.sharedUser().studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = Student.sharedUser().studentLocations[indexPath.row]
        let app = UIApplication.shared
        if let toOpen = student.mediaURL {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        }

}

}
