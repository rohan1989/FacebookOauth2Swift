//
//  ViewController.swift
//  FacebookOauth2Swift
//
//  Created by Rohan Sonawane on 03/12/16.
//  Copyright © 2016 Rohan Sonawane. All rights reserved.
//

import UIKit

struct MainViewControllerConstants {
    static let photosCollectionSegueIdentifier = "showPhotosCollectionView"
}
class MainViewController: UIViewController {

    //store "FacebookImage" objects
    var imagesArray:Array<FacebookImage>?
    
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationViewController = segue.destination as! PhotosCollectionViewController
            destinationViewController.imagesArray = sender as! Array<FacebookImage>?
    }

    // MARK: ---------- Private Functions ----------
    
    /**
     Push PhotosViewController
     
     @param None.
     
     @return None.
     */
    private func seePhotosViewController(){
        self.performSegue(withIdentifier: MainViewControllerConstants.photosCollectionSegueIdentifier, sender: self.imagesArray)
    }
    
    /**
     Generalise method to show alerts
     
     @param title -- Alert Title.
     
     @param message -- Alert message.
     
     @return None.
     */
    private func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: ---------- Button Actions ----------
    @IBAction func loginWithFacebookButtonAction(_ sender: Any) {
        
        //check empty array
        if self.imagesArray?.count != nil{
            self.seePhotosViewController()
            return
        }
        
        self.activityIndicator.startAnimating()
        
        let facebookManager = FacebookManager()
        facebookManager.loginWithFacebookAndGetPhotos(viewController: self, completionWithPhotos: {photosArray, error in
            DispatchQueue.main.async() { () -> Void in
                self.activityIndicator.stopAnimating()

                if((error?.code) != 111){
                    self.imagesArray = photosArray as? Array<FacebookImage>
                    self.loginWithFacebookButton.setTitle("See Facebook Photos", for: UIControlState.normal)
                    self.seePhotosViewController()
                }
                else{
                    self.showAlert(title: "Error Occurred", message: (error?.localizedDescription)!)
                }
            }
        })
    }
}

