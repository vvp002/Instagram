//
//  LoginViewController.swift
//  Instagram
//
//  Created by Vivian Pham on 3/11/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSignin(_ sender: Any) {
        
        //Let the user log in
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) {
                (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                print("You're Logged In!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) -> Void in
            if success {
                print("Yay, created a user")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription ?? "")
                
                if error?._code == 202 {
                    print("Username is taken")
                }
            }
        }
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
