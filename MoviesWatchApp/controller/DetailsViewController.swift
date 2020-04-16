//
//  DetailsViewController.swift
//  MoviesWatchApp
//
//  Created by Mostafa Samir on 1/6/20.
//  Copyright © 2020 AhmedSaber. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
class DetailsViewController: UIViewController , UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var buttonColor: UIButton!
    
    @IBOutlet weak var Reviews: UICollectionView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDate: UILabel!
  
    @IBOutlet weak var movieRate: CosmosView!
    
    @IBOutlet weak var movieDetails: UITableView!
    @IBOutlet weak var movieDescription: UITextView!
    var model : MovieModel = MovieModel()
    var netWorkModel = NetWorkModel.netWorkModel
    var movieReviewsList:[ReviewsModel] = []
    var movieVideosList :[VideosModel] = []
    var urlBase : String?
    var videoUrl : String?
   
    var favouriteMoveis :[MovieModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //buttonColor.setImage(UIImage.init(named: "unselected.png"), for: UIControl.State.normal)
        //buttonColor.setImage(UIImage.init(named: "selected.png"), for: UIControl.State.selected)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var id = String(model.id as! Int)
        print("id \(id)")
        urlBase = "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=c69e24b3142fbe4565740ccc74c35fd7"
        videoUrl = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=c69e24b3142fbe4565740ccc74c35fd7"
        movieTitle.text = model.title
        let year = model.releaseDate?.split(separator: "-")
        if let x = year
        {
            movieDate.text = String(x[0])
        }
        
        
        movieImage.sd_setImage(with: URL(string: model.poster!), completed: nil)
        movieDescription.text = model.overView
        movieRate.rating = ((model.rating)as!Double)/2
        movieReviewsList = []
        netWorkModel.getMovieReviews(urlBase: urlBase!)
        netWorkModel.getMovieVideo(urlBase: videoUrl!)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load reviews"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(loadVedios(notification:)), name: NSNotification.Name(rawValue: "load videos"), object: nil)
        var deleted = 0
        let coreModel = CoreModel.coreModel
        favouriteMoveis = coreModel.fetchFavourite()
        if(favouriteMoveis.count != 0 )
        {
            
            for item in favouriteMoveis
            {
                if ( item.id == model.id)
                {
                    buttonColor.tintColor = UIColor.gray
                }
            }
            if(deleted == 0)
            {
                buttonColor.tintColor = UIColor.red
                
            }
        }
//        else
//        {
//            buttonColor.tintColor = UIColor.red
//            
//        }
    }
    @objc func loadList(notification: NSNotification) {
        movieReviewsList = notification.object as! Array
        print("count movieReviews = ",movieReviewsList.count)
        Reviews.reloadData()
    }
    @objc func loadVedios (notification: NSNotification) {
        movieVideosList = notification.object as! Array
        print("count moviesVedios= ",movieVideosList.count)
        movieDetails.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func favouritClicked(_ sender: Any) {
        var deleted = 0
         let coreModel = CoreModel.coreModel
        favouriteMoveis = coreModel.fetchFavourite()
        if(favouriteMoveis.count != 0 )
        {
            
        for item in favouriteMoveis
        {
            if ( item.id == model.id)
            {
                coreModel.deleteItemFavourites(model: model)
                print("delete ")
                 buttonColor.tintColor = UIColor.gray
                deleted = 1
            }
        }
         if(deleted == 0)
         {
            buttonColor.tintColor = UIColor.red
            buttonColor.isSelected = true
            coreModel.saveFavourite(model:model)
            print("save ")
        }
        }else
        {
            buttonColor.tintColor = UIColor.red
            buttonColor.isSelected = true
            coreModel.saveFavourite(model:model)
            print("save ")
        }
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movieVideosList.count
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        
            var video = movieVideosList[indexPath.row]
            cell.textLabel?.text = video.name
            cell.imageView?.image = UIImage.init(named: "youtube.png")
    
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0)
        {
        
            var video = movieVideosList[indexPath.row]
            var key = video.key as! String
            var youtubeUrl = URL(string:"youtube://\(key)")!
            print("you")
            print(youtubeUrl.absoluteString)
            if UIApplication.shared.canOpenURL(youtubeUrl){
                UIApplication.shared.openURL(youtubeUrl)
            } else{
                youtubeUrl = URL(string:"https://www.youtube.com/watch?v=\(key)")!
                print("link")
                print(youtubeUrl.absoluteString)
                UIApplication.shared.openURL(youtubeUrl)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
            return "trailers"
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(movieReviewsList.count==0)
        {return 1}
           return movieReviewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReviewCollectionViewCell
        
        if(movieReviewsList.count==0)
        {
            cell.reviewTxt.text = "Sorry.....No Comments Found !!!"
            cell.ReviewerImag.isHidden = true
            cell.ReviewerName.isHidden = true
        }
        else{
            let reviews = movieReviewsList[indexPath.row]
            cell.ReviewerImag.isHidden = false
            cell.ReviewerName.isHidden = false
            cell.reviewTxt.text = reviews.content
            
            cell.ReviewerName.text=reviews.author
            cell.ReviewerImag.image = UIImage.init(named: "review.png")
        
        }
        return cell
    }
   
    

}

