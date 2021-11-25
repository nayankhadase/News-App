//
//  DetailsViewController.swift
//  News App with JSONdecoder
//
//  Created by nayan.khadase on 18/11/21.
//  Copyright © 2021 nayan.khadase. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDesc: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsPubDate: UILabel!
    
    
    var titleN: String?
    var descN: String?
    var imageN: UIImage?
    var newsDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        changeImageLayout()
    }


    func updateUI(){
        newsTitle.text = titleN
        newsDesc.text = descN
        newsImage.image = imageN
        newsPubDate.text = newsDate + " hours ago."
    }
    
    
    func changeImageLayout(){
        newsImage.layer.cornerRadius = 14
        newsImage.layer.borderWidth = 3
        newsImage.clipsToBounds = true
    }

}
