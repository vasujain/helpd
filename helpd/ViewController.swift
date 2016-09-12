//
//  ViewController.swift
//  helpd
//
//  Created by Jain, Vasu on 9/11/16.
//  Copyright © 2016 Jain, Vasu. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        labelCopyRight.font = labelCopyRight.font.withSize(20);
        helpdHeaderLabel.font = helpdHeaderLabel.font.withSize(42);

        //[HMNDeviceGeneral connectToMasterDevice];
    }


    @IBAction func sendMsgButton(_ sender: AnyObject) {
        print(inputTextHome);
        sendGetRequest(inputTextHome: inputTextHome.text);
        inputTextHome.text = "Your response has been captured, we are processing it.";
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var inputTextHome: UITextView!
    @IBOutlet weak var helpdHeaderLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var labelCopyRight: UILabel!
    
    /*
        Twilio Text Messaging
    */
    func sendGetRequest(inputTextHome: String) -> Void {
        let bodyData = "&Body=" + inputTextHome;
        let headers = [
            "authorization": "Basic QUNlMTJmNjY2MTc4MmFmOWYxMWQ3NjliYzIwMDk3M2E3Mjo4YWU3MTcwZDFiZDMzMzU4ZWQwNGM1YmZlZGQ0NTBmMg==",
            "content-type": "application/x-www-form-urlencoded"
        ]
        let postData = NSMutableData(data: "To=+1 2133791500".data(using: String.Encoding.utf8)!)
        postData.append("&From=+1 4082159500".data(using: String.Encoding.utf8)!)
        postData.append(bodyData.data(using: String.Encoding.utf8)!)
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.twilio.com/2010-04-01/Accounts/ACe12f6661782af9f11d769bc200973a72/Messages.json")! as URL,
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

}

