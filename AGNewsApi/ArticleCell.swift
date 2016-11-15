//
//  ArticleCell.swift
//  AGNewsApi
//
//  Created by User on 15.11.16.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTimeLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAuthorLabel: UILabel!
    
    var photoArticle: AnyObject! {
        didSet {
            ArticleItem.photoForArticle(urlToImage:photoArticle as! String) { (image) in

                self.articleImageView.image = image

            }
        }
    }

}
