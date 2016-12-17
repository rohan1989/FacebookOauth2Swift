//
//  UIImageView+AsyncDownload.swift
//  DemoUIImage
//
//  Created by Rohan Sonawane on 16/12/16.
//  Copyright © 2016 Rohan Sonawane. All rights reserved.
//

import UIKit

private var dataCache = NSCache<NSString, UIImage>()
private var imageURL:String? = nil

extension UIImageView {
    
    func clearImageCache() {
        dataCache.removeAllObjects()
    }
    
    func asyncDownload(urlString:String?, cell: UICollectionViewCell, index:IndexPath) {
        imageURL = urlString!
        
        if let image:UIImage = dataCache.object(forKey: urlString! as NSString){
            self.image = image
        }
        else{
            self.image = nil
           URLSession.shared.dataTask(with: NSURL(string: urlString!)! as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    if let cacheImage:UIImage = dataCache.object(forKey: (response!.url!.absoluteString as NSString)){
                        if self.tag == index.item{
                            self.image = cacheImage
                        }
                    }
                    else{
                        let downloadedImage = UIImage(data: data!)
                        dataCache.setObject(downloadedImage!, forKey: (response!.url!.absoluteString as NSString))
                        if((response!.url!.absoluteString as String) == imageURL || self.tag == index.item)
                        {
                            self.image = downloadedImage
                        }
                    }
                })
            }).resume()
        }
    }
}
