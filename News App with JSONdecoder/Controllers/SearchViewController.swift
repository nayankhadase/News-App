//
//  SearchViewController.swift
//  News App with JSONdecoder
//
//  Created by nayan.khadase on 18/11/21.
//  Copyright © 2021 nayan.khadase. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var selectedIndex: Int?
    var newsParsing = NewsParsing()
    let spinning = Spinning()
    
    let defaultImage = "https://static.toiimg.com/thumb/msid-87773383,width-1070,height-580,imgsize-61438,resizemode-75,overlay-toi_sw,pt-32,y_pad-40/photo.jpg"
    
    var newsItem: NewsData?{
        didSet{
            DispatchQueue.main.async {
                
                self.spinning.stopSpinner(spinner: self.spinner)
                if (self.newsItem?.articles.count)! > 0 {
                    self.notificationLabel.isHidden = true
                    self.searchCollectionView.alpha = 1
                    self.searchCollectionView.reloadData()
                }else{
                    self.notificationLabel.isHidden = false
                    self.notificationLabel.text = "No news found, search for other keyword"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationLabel.isHidden = true
        spinning.stopSpinner(spinner: spinner)
        searchText.delegate = self
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        newsParsing.delegate = self
    }
}
//MARK: - search for news
extension SearchViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        notificationLabel.isHidden = false
        searchCollectionView.alpha = 0
        spinning.startSpinner(spinner: spinner)
        newsParsing.SearchForQuery(for: searchText.text!)
    }
}

//MARK: - collection view methods
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsItem?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        cell.newsTitle.text = newsItem?.articles[indexPath.row].title
        
        
        let imgURL = newsItem?.articles[indexPath.row].urlToImage
        let url = URL(string: imgURL ?? defaultImage)
        if let data = try? Data(contentsOf: url!){
            cell.newsImage.image = UIImage(data: data)
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "SearchToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailsViewController
        let item = newsItem?.articles[selectedIndex!]
        destinationVC.titleN = item?.title
        destinationVC.descN = item?.description
        
        let imgURL = item?.urlToImage ?? defaultImage
        destinationVC.imageN = getUIimage(from: imgURL)
        
        if let stringDate = item?.publishedAt{
            destinationVC.newsDate = getTime(from: stringDate)
        }
        
        
    }
    // get uiimage from url
    func getUIimage(from stringUrl: String) -> UIImage{
        let url = URL(string: stringUrl)
        if let data = try? Data(contentsOf: url!){
            return UIImage(data: data)!
        }
        return UIImage()
    }
    
    // get time
    func getTime(from stringData: String) -> String {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = RFC3339DateFormatter.date(from: stringData){
            let currentDate = Date()
            let difference = Calendar.current.dateComponents([.second], from: date, to: currentDate)
            let duration = difference.second
            return String(duration! / 3600)
        }
        return ""
    }
    
}


extension SearchViewController: NewsParsingDelegate{
    func didUpdateNews(newsItems: NewsData) {
        newsItem = newsItems
    }
    
    
}
