//
//  AllNewsViewController.swift
//  News App with JSONdecoder
//
//  Created by nayan.khadase on 18/11/21.
//  Copyright © 2021 nayan.khadase. All rights reserved.
//

import UIKit

class AllNewsViewController: UIViewController {
    
    var newsParsing = NewsParsing()
    let spinning = Spinning()
    
    let defaultImage = "https://static.toiimg.com/thumb/msid-87773383,width-1070,height-580,imgsize-61438,resizemode-75,overlay-toi_sw,pt-32,y_pad-40/photo.jpg"
    
     var selectedIndex: Int?
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let newsCategory = [ "General", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"]
    
    var news: NewsData?{
        didSet{
            DispatchQueue.main.async {
                self.spinning.stopSpinner(spinner: self.spinner)
                self.collectionView.alpha = 1
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsParsing.delegate = self
        self.spinning.startSpinner(spinner: spinner)
        newsParsing.searchForAllNews(for: newsCategory[0])

        newsTableView.delegate = self
        newsTableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
    }
    
}
//MARK: - table view methods
extension AllNewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCellIdentifier", for: indexPath)
        cell.textLabel?.text = newsCategory[indexPath.row]
        
        // select row at index path 0
        self.newsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.spinning.startSpinner(spinner: spinner)
        collectionView.alpha = 0
        //news?.articles.removeAll()
        newsParsing.searchForAllNews(for: newsCategory[indexPath.row])
        
    }
    
    
    
}

//MARK: - collection view methods
extension AllNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! NewsCollectionViewCell
        let articleItem = news?.articles[indexPath.row]
        cell.newsTitle.text = articleItem!.title
        
        let imgURL = articleItem?.urlToImage == nil ? defaultImage : articleItem?.urlToImage
        cell.newsImage.image = getUIimage(from: imgURL!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "AllToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailsViewController
        let item = news?.articles[selectedIndex!]
        destinationVC.titleN = item?.title
        destinationVC.descN = item?.description
        
        let imgURL = item?.urlToImage == nil ? defaultImage : item?.urlToImage
        destinationVC.imageN = getUIimage(from: imgURL!)
        
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
    

    
    
    
    
    // scale the focused item
//    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        if let index = context.nextFocusedIndexPath {
//            let cell = collectionView.cellForItem(at: index) as! NewsCollectionViewCell
//            //cell.layer.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//            cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
//
//            if let indexp = context.previouslyFocusedIndexPath{
//                let cell = collectionView.cellForItem(at: indexp) as! NewsCollectionViewCell
//                //cell.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
//
//            }
//
//        }
//    }
    
    
    
}

//MARK: - news parsing delegate
extension AllNewsViewController: NewsParsingDelegate{
    func didUpdateNews(newsItems: NewsData) {
        news = newsItems
    }
    
    
}
