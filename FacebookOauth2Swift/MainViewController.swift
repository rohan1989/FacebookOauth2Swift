//
//  ViewController.swift
//  FacebookOauth2Swift
//
//  Created by Rohan Sonawane on 03/12/16.
//  Copyright © 2016 Rohan Sonawane. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

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
        
        if "showPhotosView" == segue.identifier {
            let destinationViewController = segue.destination as! PhotosViewController
            destinationViewController.imagesArray = sender as! Array<FacebookImage>?
        }
    }

    // MARK: ---------- Private Functions ----------
    private func seePhotosViewController(){
            self.performSegue(withIdentifier: "showPhotosView", sender: self.imagesArray)
    }
    
    private func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: ---------- Button Actions ----------
    @IBAction func loginWithFacebookButtonAction(_ sender: Any) {
        
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

