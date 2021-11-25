//
//  NewsData.swift
//  News App with JSONdecoder
//
//  Created by nayan.khadase on 18/11/21.
//  Copyright © 2021 nayan.khadase. All rights reserved.
//

import Foundation
struct NewsData: Codable {
    var articles: [Articles]
}

struct Articles: Codable {
    let title: String
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    
}
