//
//  ViewController.swift
//  helpd
//
//  Created by Jain, Vasu on 9/11/16.
//  Copyright © 2016 Jain, Vasu. All rights reserved.
//

import UIKit
import Foundation

//class ViewController: UIViewController {
class ViewController: UIViewController, FBSDKLoginButtonDelegate  {

    @IBOutlet weak var sendTextButton: UIButton!
    @IBOutlet weak var inputTextHome: UITextView!
    @IBOutlet weak var helpdHeaderLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var labelCopyRight: UILabel!
    @IBOutlet weak var fbIcon: UIImageView!
    @IBOutlet weak var twitterIcon: UIImageView!
    @IBOutlet weak var githubIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Sets up App background and other images
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        fbIcon.image = UIImage(named: "facebook.png")
        twitterIcon.image = UIImage(named: "twitter.png")
        githubIcon.image = UIImage(named: "github.png")
        emailIcon.image = UIImage(named: "email.png")

        //HELPD label
        helpdHeaderLabel.textColor = UIColor.white;
        helpdHeaderLabel.font = helpdHeaderLabel.font.withSize(48);
        
        //label CopyRight
        labelCopyRight.textColor = UIColor.white;
        labelCopyRight.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        //inputTextHome
        inputTextHome.font = inputTextHome.font?.withSize(20.0)
        
        //Send Text Button
        sendTextButton.tintColor = UIColor.white;
        sendTextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        sendTextButton.layer.cornerRadius = 8
        sendTextButton.layer.borderWidth = 2
        sendTextButton.backgroundColor = UIColor.clear
        sendTextButton.layer.borderColor = UIColor.white.cgColor
        
        //fb login button
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
    }

    //Calls this function to perform button press action
    @IBAction func sendMsgButton(_ sender: AnyObject) {
        print(inputTextHome);
        sendTextUsingTwilioRequest(inputTextHome: inputTextHome.text);
        inputTextHome.text = "Your response has been captured, we are processing it.";
    }
    @IBAction func icon1_tap_action(_ sender: AnyObject) {
        let infoPlist = Bundle.main.infoDictionary
        let icon1_url = infoPlist?["icon1_url"] as! String
        UIApplication.shared.open(NSURL(string: icon1_url)! as URL);
    }
    @IBAction func icon2_tap_action(_ sender: AnyObject) {
        let infoPlist = Bundle.main.infoDictionary
        let icon2_url = infoPlist?["icon2_url"] as! String
        UIApplication.shared.open(NSURL(string: icon2_url)! as URL);
    }
    @IBAction func icon3_tapped_action(_ sender: AnyObject) {
        let infoPlist = Bundle.main.infoDictionary
        let icon3_url = infoPlist?["icon3_url"] as! String
        UIApplication.shared.open(NSURL(string: icon3_url)! as URL);

    }
    @IBAction func icon4_tapped_action(_ sender: AnyObject) {
        print("icon4_tapped_action invoked");
        let infoPlist = Bundle.main.infoDictionary
        let icon4_url = infoPlist?["icon4_url"] as! String
        UIApplication.shared.open(NSURL(string: icon4_url)! as URL);
    }
    //Calls this function to send Twilio Text Message
    func sendTextUsingTwilioRequest(inputTextHome: String) -> Void {
        let infoPlist = Bundle.main.infoDictionary
        let authToken = infoPlist?["AuthToken"] as! String
        let twilioApiURL = infoPlist?["TwilioApiURL"] as! String
        let twilioToPhone = infoPlist?["TwilioToPhone"] as! String
        let twilioFromPhone = infoPlist?["TwilioFromPhone"] as! String
        let bodyData = "&Body=" + inputTextHome
        let toPhoneData = "To=" + twilioToPhone
        let fromPhoneData = "&From=" + twilioFromPhone

        let headers = [
            "authorization": authToken,
            "content-type": "application/x-www-form-urlencoded"
        ]
        let postData = NSMutableData(data: toPhoneData.data(using: String.Encoding.utf8)!)
        postData.append(fromPhoneData.data(using: String.Encoding.utf8)!)
        postData.append(bodyData.data(using: String.Encoding.utf8)!)
        let request = NSMutableURLRequest(url: NSURL(string: twilioApiURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })
        dataTask.resume()
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    // FB Code
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        fetchProfile()
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                return
            }
            
            var _ = user["email"] as? (AnyObject)
            let firstName = user["first_name"] as? String
            let lastName = user["last_name"] as? String
            
            self.nameLabel.text = "\(firstName!) \(lastName!)"
            
            var pictureUrl = ""
//            
//            if let picture = user["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
//                pictureUrl = url
//            }
            
            let url = NSURL(string: pictureUrl)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.userImageView.image = image
                })
                
            }).resume()
            
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

}

