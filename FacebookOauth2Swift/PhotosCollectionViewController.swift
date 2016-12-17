//
//  PhotosCollectionViewController.swift
//  FacebookOauth2Swift
//
//  Created by Rohan Sonawane on 08/12/16.
//  Copyright © 2016 Rohan Sonawane. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let reuseIdentifier = "collectionViewCellReuseIdentifier"
    var imagesArray:Array<FacebookImage>?
    var blurEffectView:UIVisualEffectView!
    var isImageCacheCleared:Bool = false
    
    
    @IBOutlet weak var popupImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        popupImageView.layer.cornerRadius = 8
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.popupImageViewTapGesture(_:)))
        popupImageView.addGestureRecognizer(tapGesture)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isHidden = true
        blurEffectView.alpha = 0.0
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, belowSubview: popupImageView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ---------- Private Functions ----------
    /**
     Handles popup image view tap gesture
     
     @param sender: UITapGestureRecognizer
     
     @return None.
     */
    func popupImageViewTapGesture(_ sender: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5, animations: {
            self.popupImageView.alpha = 0.0
            self.blurEffectView.alpha = 0.0
        }, completion: { (finish) in
            self.popupImageView.isHidden = true
            self.blurEffectView.isHidden = true
        })
        
    }
    
    // MARK: ---------- Delegates & Datasources ----------
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArray!.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotosCollectionViewCell
        let facebookImage:FacebookImage = imagesArray![indexPath.item]
        if !isImageCacheCleared {
            cell.photoImageView.clearImageCache()
            isImageCacheCleared = true
        }
        cell.photoImageView.asyncDownload(urlString: facebookImage.imageSource, cell: cell, index: indexPath)
        cell.photoImageView.tag = indexPath.item
        cell.backgroundColor = UIColor.black
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCollectionViewCell
        self.popupImageView.image = cell.photoImageView.image
        self.popupImageView.alpha = 0.0
        self.popupImageView.isHidden = false
        blurEffectView.isHidden = false
        blurEffectView.alpha = 0.0
        
        //popup animation
        UIView.animate(withDuration: 0.5, animations: {
            self.popupImageView.alpha = 1.0
            self.blurEffectView.alpha = 1.0
        }, completion: { (finish) in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 100, height: 100)
        return size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25.0
    }
}
