










//
//  ViewController.swift
//  GetAndPostApi
//
//  Created by basavaraj on 10/07/18.
//  Copyright © 2018 jovin. All rights reserved.
//

import UIKit


class ViewController: UIViewController , NSURLConnectionDelegate, NSURLConnectionDataDelegate{
    
    @IBOutlet weak var doorName: UITextField!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var homeName: UITextField!
    
    @IBOutlet weak var deviceId: UITextField!
    
    @IBOutlet weak var userId: UITextField!
    
    var postConnection: NSURLConnection?
    var recieveData: NSMutableData = NSMutableData()
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.stopAnimating()
    }
    
    
    
    func makePostRequest(){
        
        let url : String = mainURL + "add-door"
        var body = ["door_name":self.doorName.text!,"home_name":self.homeName.text!,"device_id":self.deviceId.text!,"door_type":"master","user_id":self.userId.text!]
        
        var jsonData:Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url)! as URL
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        postConnection = NSURLConnection(request: request as URLRequest, delegate: self)
        //  postConnection = NSURLConnection(request: request as URLRequest, delegate: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitPostRequest(_ sender: Any) {
        
        //  makePostRequest()
        
        activityIndicatorView.startAnimating()
        
        makePostRequest()
        
    }
    
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("Operation Failed",error.localizedDescription)
        let title = "Alert!"
        let message = "Internet connection is appears to be slow"
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        activityIndicatorView.stopAnimating()
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        self.recieveData = NSMutableData()
        print("inside didRecieve response")
        
    }
    
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.recieveData.append(data as Data)
        print("inside didRecieve data")
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        activityIndicatorView.stopAnimating()
        print("connection finished loading")
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: recieveData as Data, options: []) as? NSDictionary {
                print(jsonResult)
                let title = "status"
                let message = jsonResult["status"]
                let alertController = UIAlertController(title: title, message: message as! String, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    if message! as! String == "success"{
                        
                        self.gotoNextController()
                    }
                }
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    func gotoNextController() {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        self.navigationController?.pushViewController(vc, animated: true)
    }
}













