//
//  PhotosViewController.swift
//  FacebookOauth2Swift
//
//  Created by Rohan Sonawane on 04/12/16.
//  Copyright © 2016 Rohan Sonawane. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    var imagesArray:Array<FacebookImage>?
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for facebookImage:FacebookImage in (imagesArray)!{
            print(facebookImage.imageSource!)
        }
        self.addImagesToScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: ---------- Private Functions ----------
    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    private func addImagesToScrollView(){
        var imageX:CGFloat = 10.0
        let heightOffset:CGFloat = 100.0
        
        for facebookImage:FacebookImage in imagesArray! {
            let rect = CGRect(x: imageX, y: 20, width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height - heightOffset)
            let imageView:UIImageView = UIImageView.init(frame: rect)
            self.addShadow(view: imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = UIColor.clear
            if let checkedUrl = URL(string: facebookImage.imageSource!) {
                getDataFromUrl(url: checkedUrl) { (data, response, error)  in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() { () -> Void in
                        imageView.image = UIImage(data: data)
                    }
                }
            }
            
            imageScrollView.addSubview(imageView)
            imageX += UIScreen.main.bounds.size.width
        }
        let arrayCount = CGFloat((imagesArray?.count)!)
        let size = CGSize(width: (UIScreen.main.bounds.size.width) * arrayCount, height: UIScreen.main.bounds.size.height - heightOffset)
        imageScrollView.contentSize = size
    }
    
    private func addShadow(view:UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
    }
}
