//
//  ScourceItem.swift
//  AGNewsApi
//
//  Created by User on 13.11.16.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit

class SourceItem {
    
    var id: String?
    var name: String?
    var url: String?
    var urlToLogoSmall: String?
    var category: String?
    
    static func photoForSource(urlToLogoSmall: String, completion:@escaping (_ image:UIImage) -> Void) {
        
        let url = URL(string: urlToLogoSmall)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let request = URLRequest(url:url!)
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
