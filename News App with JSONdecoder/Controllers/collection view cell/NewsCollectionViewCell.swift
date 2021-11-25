//
//  NewsCollectionViewCell.swift
//  News App with JSONdecoder
//
//  Created by nayan.khadase on 18/11/21.
//  Copyright © 2021 nayan.khadase. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.layer.borderColor = #colorLiteral(red: 0.8959674881, green: 0.901921518, blue: 0.9255301356, alpha: 1)

    }
    
}
