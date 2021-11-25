//
//  NewsModel.swift
//  News App with JSONdecoder
//
//  Created by nayan.khadase on 18/11/21.
//  Copyright © 2021 nayan.khadase. All rights reserved.
//

import Foundation
struct NewsModel {
    let title: String
    let desc: String?
    let imageURL: String?
    let publishDate: String?
    init(title: String, desc: String?, imageURL: String?, publishDate: String?) {
        self.title = title
        self.desc = desc
        self.imageURL = imageURL
        self.publishDate = publishDate
    }
}
