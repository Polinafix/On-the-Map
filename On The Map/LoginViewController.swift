//
//  LoginViewController.swift
//  On The Map
//
//  Created by Polina Fiksson on 24/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
     var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self

    }
    
    //hide keyboard when user touches outside of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard when pressing the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
   
    
    private func completeLogin() {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapNavController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)  
    }
    
    @IBAction func loginWithFb(_ sender: UIButton) {
        //start the indicator
        activityIndicator.startAnimating()
        // Get the access token from facebook
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email, .userFriends], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("The user cancelled login")
            case .success(grantedPermissions: _, declinedPermissions: _, token: let theToken):
                Student.sharedUser().fbToken = theToken.authenticationToken
                self.continueLogin()
                
            }
        }
        
       
    }
    
    func continueLogin() {
        UdacityClient.sharedInstance().loginWithFacebook(fbToken: Student.sharedUser().fbToken) { (success, errorString) in
            
            performUIUpdatesOnMain {
                
                self.activityIndicator.stopAnimating()
                if success {
                    self.completeLogin()
                }else if errorString != nil{
                    self.showAlert(title: "Login Failed", message: errorString)
                }else{
                    self.showAlert(title: "Login Failed", message: "Incorrect credentials were provided.")
                }
                
            }
            
        }
    }
    
    //MARK: Login process
    @IBAction func loginInitiated(_ sender: UIButton) {
        //start the indicator
        activityIndicator.startAnimating()
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            print("Username or Password Empty.")
        } else {
            //call the login method from the client
            UdacityClient.sharedInstance().login(username: emailTextField.text!, password: passwordTextField.text!, completionHandlerForLogin: { (success, errorString) in
                
                performUIUpdatesOnMain {
                    
                    self.activityIndicator.stopAnimating()
                    if success {
                        self.completeLogin()
                    }else if errorString != nil{
                        self.showAlert(title: "Login Failed", message: errorString)
                    }else{
                        self.showAlert(title: "Login Failed", message: "Incorrect credentials were provided.")
                    }

                }
            })
    }
}
    
    func showAlert(title:String, message:String?) {
        
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func signUp(_ sender: UIButton) {
       
            let app = UIApplication.shared
            let toOpen = "https://www.udacity.com/account/auth#!/signup"
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
    
    }
    
    }
   



