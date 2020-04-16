//
//  FavouritesControllerCollectionViewController.swift
//  MoviesWatchApp
//
//  Created by Mostafa Samir on 1/8/20.
//  Copyright © 2020 AhmedSaber. All rights reserved.
//

import UIKit
import SDWebImage
private let reuseIdentifier = "cell"
var favouriteMoveis : [MovieModel] = []
var model : MovieModel?
class FavouritesController: UICollectionViewController ,UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let coreModel = CoreModel.coreModel
        favouriteMoveis = coreModel.fetchFavourite()
        print(favouriteMoveis.count)
       self.collectionView.reloadData()
        
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteMoveis.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavouriteCell
        var movieModel = MovieModel()
        if(favouriteMoveis.count>0)
        {
            movieModel = favouriteMoveis[indexPath.row]
            cell.favouriteImage.sd_setImage(with: URL(string: movieModel.poster!), completed: nil)
        }
    
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailsViewController
        destinationVC.model = model!
    }
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = UIScreen.main.bounds.size.width/2
        let h = w * 1.5
        return CGSize(width: w, height: h)
    }
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        model = favouriteMoveis[indexPath.row]
        performSegue(withIdentifier: "details", sender: self)
        return true
    }


}
