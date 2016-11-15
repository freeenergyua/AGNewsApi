//
//  SourcesVC.swift
//  AGNewsApi
//
//  Created by User on 15.11.16.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit

class SourcesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoriesSegmentedControler: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
            {
                case 0:
                    sortedArr = self.sourceArray;
                    DispatchQueue.main.async {
                        self.tableView.reloadData();
                    }
                case 1:
                    self.arrForCategory(category: "business");
            
                case 2:
                    self.arrForCategory(category: "sport");
            
                case 3:
                    self.arrForCategory(category: "general");
            
                default:
                break;
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var sourceArray = [SourceItem]()
    var sortedArr = [SourceItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSourcesList()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func arrForCategory(category: String) {
        self.sortedArr = []
        for item in self.sourceArray {
            if item.category == category {
                self.sortedArr.append(item)
            }
        }
        DispatchQueue.main.async {
        self.tableView.reloadData();
        }
        print("\(category) - \(self.sortedArr.count)")
    }
    
    func getSourcesList() {
        
        // Set up the URL request
        let stringUrl: String = BASE_SOURCE_URL
        guard let url = URL(string: stringUrl) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                guard let sourcesArr = json["sources"] as? [[String:Any]] else {
                    print("Could not get sources from JSON")
                    return
                }
                
                //parse item to array of Source Items
                for item in sourcesArr {
                    
                    let sourceItem = self.parseJSONSourceItem(jsonItem: item)
                    self.sourceArray.append(sourceItem)
                }
                
                self.sortedArr = self.sourceArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
        
    }
    
    func parseJSONSourceItem(jsonItem:[String:Any]) -> SourceItem {
        
        let sourceItem = SourceItem()
        
        if let id = jsonItem["id"] as? String {
            sourceItem.id = id
        }
        
        if let name = jsonItem["name"] as? String {
            sourceItem.name = name
        }
        if let category = jsonItem["category"] as? String {
            sourceItem.category = category
        } else {
            sourceItem.category = "undefined"
        }
        
        if let url = jsonItem["url"] as? String {
            sourceItem.url = url
        }
        if let urlToLogo = jsonItem["urlsToLogos"] as? [String: Any] {
            if let urlToLogoSmall = urlToLogo["small"] as? String {
                sourceItem.urlToLogoSmall = urlToLogoSmall
            }
        }
        
        return sourceItem
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SourceCell
        let sourceItem = self.sortedArr[indexPath.row]
        cell.photoSmall = sourceItem.urlToLogoSmall as AnyObject!
        cell.sourceNameLabel.text = sourceItem.name! as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sourceItem = self.sortedArr[indexPath.row]
        let sourceID = sourceItem.id
        
        performSegue(withIdentifier: "ArticleSearchVC", sender:sourceID )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ArticleSearchVC" {
            if let articleSearchVC = segue.destination as? ArticleSearchVC {
                if let sourceID = sender as? String {
                    articleSearchVC.sourceID = sourceID
                }
            }
        }
        
    }
}
