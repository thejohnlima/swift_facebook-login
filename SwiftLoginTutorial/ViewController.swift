//
//  ViewController.swift
//  SwiftLoginTutorial
//
//  Created by John Silva on 6/24/15.
//  Copyright © 2015 John Silva. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var loginButton: FBSDKLoginButton!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in")
        }else {
            print("Logged in")
            self.returnUserData()
        }
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:
    // MARK: login button delegate
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if (error == nil) {
            print("login complete")
            self.returnUserData()
        }else {
            print("error: \(error.localizedDescription)")
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
        self.name.hidden = true
        self.gender.hidden = true
        self.email.hidden = true
        self.picture.hidden = true
        //viewDidLoad()
    }
    
    // MARK:
    // MARK: methods
    func returnUserData() {
    
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            
            if (error != nil) {
                print("error: \(error)")
            }else {
                
                print("user: \(result)")
                self.name.text = result.valueForKey("name") as? String
                self.gender.text = result.valueForKey("gender") as? String
                self.email.text = result.valueForKey("email") as? String
                
            }
            
        }
        
        let pictureRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            
            if (error != nil) {
                print("picture error: \(error)")
            }else {
                print("picture: \(result)")
                let url = NSURL(string: result.valueForKeyPath("data.url") as! String)
                self.downloadImage(url!, handler: { (image, error) -> Void in
                    self.picture.image = image
                })
            }
            
        }
        
        self.name.hidden = false
        self.gender.hidden = false
        self.email.hidden = false
        self.picture.hidden = false
        
    }
    
    func downloadImage(url: NSURL, handler: ((image: UIImage, NSError!) -> Void)) {
        let imageRequest: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(imageRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{response, data, error in handler(image: UIImage(data: data!)!, error)})
    }
    
}

