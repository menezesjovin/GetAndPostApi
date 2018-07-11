//
//  ViewController2.swift
//  GetAndPostApi
//
//  Created by basavaraj on 10/07/18.
//  Copyright © 2018 jovin. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lockMonitorTable: UITableView!
    var dictionaryOfData = [String : [String  : String]]()
    var doorLock = [LockMonitor]()
    
    var recieveData: NSMutableData = NSMutableData()
    var getConnection: NSURLConnection?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeGetRequest()
        
        // Do any additional setup after loading the view.
    }
    
    func makeGetRequest(){
        let url1  = mainURL + "doors/100"
        let url = URL(string : url1)!
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = url
        request.httpMethod = "GET"
        getConnection = NSURLConnection(request: request as URLRequest, delegate: self)
        print("view load ended")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("Operation Failed",error.localizedDescription)
        let title = "!"
        let message = "Internet is slow or disconnected"
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        self.recieveData = NSMutableData()
        print("inside didRecieve response")
        
    }
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.recieveData.append(data as Data)
        print("inside didRecieve data")
    }
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        print("connection finished loading")
        
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: recieveData as Data, options: []) as? NSDictionary {
                // print(jsonResult)
                let records = jsonResult["records"] as! NSArray
                for individualRecord in records{
                    var doorName : String?
                    var homeName : String?
                    doorName = (individualRecord as! [String:Any])["door_name"]! as? String
                    homeName = ((individualRecord as! [String:Any])["home_name"]! as! String)
                    let lockMonitorObject = LockMonitor(doorName: doorName!, homeName: homeName!)
                    doorLock.append(lockMonitorObject)
                    
                }
                
                
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.lockMonitorTable.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return doorLock.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = lockMonitorTable.dequeueReusableCell(withIdentifier: "Reusable_Id", for: indexPath) as! TableViewCell1
        let individualPerson = doorLock[indexPath.row]
        cell.doorLabel?.text = individualPerson.doorName
        cell.homeLabel?.text = individualPerson.homeName
        return cell
        
        
    }
    
    
    
    
}
