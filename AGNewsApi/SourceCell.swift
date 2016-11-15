//
//  ScourceCell.swift
//  AGNewsApi
//
//  Created by User on 13.11.16.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit

class SourceCell: UITableViewCell {
  
    @IBOutlet weak var sourceLogoImg: UIImageView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    
    var photoSmall: AnyObject! {
        didSet {
            SourceItem.photoForSource(urlToLogoSmall:photoSmall as! String) { (image) in

                self.sourceLogoImg.image = image

            }
        }    }

}
