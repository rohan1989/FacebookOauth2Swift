//
//  ParsingManager.swift
//  FacebookOauth2Swift
//
//  Created by Rohan Sonawane on 04/12/16.
//  Copyright © 2016 Rohan Sonawane. All rights reserved.
//

import UIKit

struct ParsingManagerConstants {
    static let dataKey = "data"
    static let imagesKey = "images"
    static let idKey = "id"
    static let widthKey = "width"
    static let heightKey = "height"
    static let sourceKey = "source"
    static let errorDomain = "Facebook photos not found"
}

open class ParsingManager: NSObject {

    func parseFacebookPhotos(responseData:Data, completionWithPhotos: @escaping (_ photosArray: Array<FacebookImage>?, _ error:NSError?) -> Void) {
        let json = try? JSONSerialization.jsonObject(with: responseData, options: [])
        
        if let dictionary = json as? [String: Any] {
            if dictionary[ParsingManagerConstants.dataKey] != nil{
                let dataArray:NSArray = dictionary[ParsingManagerConstants.dataKey] as! NSArray
                var photosArray:Array<FacebookImage> = []
                
                for i in 0 ..< dataArray.count {
                    let dictResult = dataArray.object(at: i) as! NSDictionary
                    print(dictResult)
                    let image:FacebookImage = FacebookImage()
                    image.imageID = dictResult[ParsingManagerConstants.idKey] as? String
                    
                    let imageArray:NSArray = dictResult[ParsingManagerConstants.imagesKey] as! NSArray
                    let imageDicResult = imageArray.object(at: 0) as! NSDictionary
                    image.imageWidth = imageDicResult[ParsingManagerConstants.widthKey] as? String
                    image.imageHeight = imageDicResult[ParsingManagerConstants.heightKey] as? String
                    image.imageSource = imageDicResult[ParsingManagerConstants.sourceKey] as? String

                    photosArray.append(image)
                }
                completionWithPhotos(photosArray, NSError(domain: "", code: 222, userInfo: nil))
            }
            else{
                completionWithPhotos(nil, NSError(domain: ParsingManagerConstants.errorDomain, code: 111, userInfo: nil))
            }
        }
        else{
            completionWithPhotos(nil, NSError(domain: ParsingManagerConstants.errorDomain, code: 111, userInfo: nil))
        }
    }
}
