//
//  ViewOne.swift
//  Innata
//
//  Created by Ivan Chau on 1/20/17.
//  Copyright © 2017 Innata. All rights reserved.
//

import UIKit

class ViewOne: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var graphButton : UIBarButtonItem!
    @IBOutlet weak var tableView : UITableView!
    var array = NSArray()
    var gArray = NSMutableArray()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle:nil), forCellReuseIdentifier: "InnataCell")

        let url = "http://innata.herokuapp.com/"
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let postData = NSMutableData(data: ("id=" + UserDefaults.standard.string(forKey: "account")!).data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: url + "getPurchases")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if(httpResponse?.statusCode == 200){
                    do{
                        self.array = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        print(self.array)
                        self.tableView.reloadData()
                    }catch{
                    
                    }
                }
            }
        })
        
        dataTask.resume()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InnataCell", for: indexPath) as! TableViewCell
        let object = self.array[indexPath.row] as! NSDictionary
        var a = round(100.0 * (object["amount"]as! Double)) / 100.0
        cell.dolla.text = "$" + String(a)
        cell.merchant.text = object["merchant_name"] as? String
        cell.date.text = object["purchase_date"] as? String
        cell.desc.text = object["description"] as? String
        gArray.add(object["geocode"])
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    @IBAction func showGraph(sender: AnyObject){
        print("button pressed")
        var VThree : ViewThree = ViewThree(nibName:"ViewThree", bundle:nil)
        VThree.geoArray = self.gArray
        VThree.purchasesArray = self.array
        present(VThree, animated: true) { 
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
