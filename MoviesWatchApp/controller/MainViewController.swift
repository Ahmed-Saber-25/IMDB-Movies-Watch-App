//
//  MainViewController.swift
//  MovieAppProject
//
//  Created by Mostafa Samir on 1/2/20.
//  Copyright © 2020 AhmedSaber. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import SDWebImage
import ReachabilitySwift
import RevealingSplashView

class MainViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    var detailMovie : DetailsViewController?
    let list = ["most popular ","high rated"]
    var moviesList : [MovieModel] = []
    let coreModel = CoreModel.coreModel
    let urlBase = "http://api.themoviedb.org/3/discover/movie?api_key=c69e24b3142fbe4565740ccc74c35fd7"
    let urlBasePopularity = "http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=c69e24b3142fbe4565740ccc74c35fd7"
    let urlBaseRate = "http://api.themoviedb.org/3/discover/movie?sort_by=vote_count.desc&api_key=c69e24b3142fbe4565740ccc74c35fd7"
    var netWorkModel = NetWorkModel.netWorkModel
    @IBOutlet weak var barMenue: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "imdb.jpg")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red:0.11, green:0.56, blue:0.95, alpha:1.0))
        revealingSplashView.animationType = SplashAnimationType.rotateOut
        self.view.addSubview(revealingSplashView)
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        navigationController?.navigationBar.barTintColor = UIColor.black
        detailMovie = self.storyboard?.instantiateViewController(withIdentifier: "detailsView") as! DetailsViewController
        let reachability = try! Reachability()
        
        reachability!.whenReachable = { reachability in
            if reachability.currentReachabilityStatus == .reachableViaWiFi {
                
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            
            self.netWorkModel.getMovieDetails(urlBase: self.urlBase)
            
        }
        reachability!.whenUnreachable = { _ in
            let alert = UIAlertController(title: "Network Notify", message: "NetWork Failure", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.moviesList = self.coreModel.fetchData()
             self.collectionView.reloadData()
        }
        
        do {
            try reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        reachability?.stopNotifier()
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        
        
    }
    @objc func loadList(notification: NSNotification) {
        moviesList = []
        moviesList = coreModel.fetchData()
        self.collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return moviesList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCellController
        var movieModel = MovieModel()
        if(moviesList.count>0)
        {
        movieModel = moviesList[indexPath.row]
        cell.movieCell.sd_setImage(with: URL(string: movieModel.poster!), completed: nil)
        }
        
        return cell
    }
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        var movieModel = MovieModel()
        if(moviesList.count>0)
        {
            movieModel = moviesList[indexPath.row]
            detailMovie?.model = movieModel
            self.navigationController?.pushViewController(detailMovie!, animated: true)
        
        }
        
     return true
     }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width:(collectionView.frame.width/2),height:(collectionView.frame.height/2) as CGFloat)
    }
    @IBAction func onClickMenue(_ sender: Any) {
        print("hello")
        let menuView = BTNavigationDropdownMenu(title: "",  items: list)
        menuView.cellBackgroundColor = UIColor.black
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelAlignment = NSTextAlignment.right
        menuView.menuTitleColor = UIColor.white
        self.barMenue.customView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            if indexPath == 0
            {
            print("Did select item at index: \(indexPath)")
                self!.netWorkModel.getMovieDetails(urlBase: self!.urlBasePopularity)
            }else
            {
             print("Did select item at index: \(indexPath)")
              self!.netWorkModel.getMovieDetails(urlBase: self!.urlBaseRate)
            }
        }
    }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
