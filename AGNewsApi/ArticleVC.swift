//
//  ArticleVC.swift
//  AGNewsApi
//
//  Created by User on 15.11.16.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit

class ArticleVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var articleURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = self.articleURL {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        } else {
            let url = URL(string:"google.com")
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
        }
  
    }

}
