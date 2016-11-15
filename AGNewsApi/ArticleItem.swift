//
//  ArticleItem.swift
//  AGNewsApi
//
//  Created by User on 15.11.16.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit
import SAMCache

class ArticleItem {
    
    var author: String?
    var title: String?
    var url: String?
    var urlToImage: String?
    var timePublished: String?
    
    static func photoForArticle(urlToImage: String, completion:@escaping (_ image:UIImage) -> Void) {
        
        let key = "\(urlToImage)"
        
        if let img = SAMCache.shared().image(forKey: key) {
            completion(img)
        } else {
        
        guard let url = URL(string: urlToImage) else {
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let request = URLRequest(url:url)
        let task = session.downloadTask(with: request) { (localFile, response, error) in
            if error == nil {
                do {
                    let data = try Data(contentsOf: localFile!)
                    let img = UIImage(data: data as Data)
                    
                    DispatchQueue.main.async {
                        completion(img!)
                    }
                    
                } catch let error {
                    
                    print(error)
                }
            }
        }
        task.resume()
    }
    }
}
