//
//  ArticleSearchVC.swift
//  AGNewsApi
//
//  Created by User on 15.11.16.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit

class ArticleSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sourceID: String = ""
    var articlesArray = [ArticleItem]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.getArticlesList()
    }

    func getArticlesList() {
        
        // Set up the URL request
        let stringUrl: String = BASE_ARTICLE_URL + sourceID + API_KEY
        
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
                
                guard let sourcesArr = json["articles"] as? [[String:Any]] else {
                    print("Could not get sources from JSON")
                    return
                }
                
                //parse item to array of Source Items
                for item in sourcesArr {       
                    let articleItem = self.parseJSONArticleItem(jsonItem: item)
                    self.articlesArray.append(articleItem)
                }
                
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
    
    func parseJSONArticleItem(jsonItem:[String:Any]) -> ArticleItem {
        
        let articleItem = ArticleItem()
        
        if let author = jsonItem["author"] as? String {
            articleItem.author = author
        } else {
            articleItem.author = ""
        }
        
        if let title = jsonItem["title"] as? String {
            articleItem.title = title
        } else {
            articleItem.title = ""
        }
        
        if let url = jsonItem["url"] as? String {
            articleItem.url = url
        } 
        
        if let urlToImage = jsonItem["urlToImage"] as? String {
            articleItem.urlToImage = urlToImage
        }
        
        if let publishedAt = jsonItem["publishedAt"] as? String {
            let string = publishedAt.replacingOccurrences(of: "T,Z",
                                                             with: " ",
                                                             options: .regularExpression,
                                                             range: nil)
            articleItem.timePublished = string
        } else {
            articleItem.timePublished = ""
        }
        
        return articleItem
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articlesArray.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        let articleItem = self.articlesArray[indexPath.row]
        
        cell.photoArticle = articleItem.urlToImage as AnyObject!
        cell.articleTimeLabel.text = articleItem.timePublished! as String
        cell.articleTitleLabel.text = articleItem.title! as String
        cell.articleAuthorLabel.text = articleItem.author! as String

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleItem = self.articlesArray[indexPath.row] 
        let stringURL = articleItem.url
        let url = URL(string:stringURL!)
        performSegue(withIdentifier: "ArticleVC", sender:url )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArticleVC" {
            if let articleVC = segue.destination as? ArticleVC {
                if let articleURL = sender as? URL {
                    articleVC.articleURL = articleURL
                }
            }
        }
    }
    
}



 
