//
//  Spinning.swift
//  News App with JSONdecoder
//
//  Created by nayan.khadase on 19/11/21.
//  Copyright © 2021 nayan.khadase. All rights reserved.
//

import UIKit
struct Spinning {
    
    func startSpinner(spinner: UIActivityIndicatorView){
        spinner.startAnimating()
    }
    func stopSpinner(spinner: UIActivityIndicatorView){
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
    }
}
