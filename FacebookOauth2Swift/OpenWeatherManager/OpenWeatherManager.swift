//
//  OpenWeatherManager.swift
//  FacebookOauth2Swift
//
//  Created by Rohan Sonawane on 06/12/16.
//  Copyright © 2016 Rohan Sonawane. All rights reserved.
//

import UIKit

class OpenWeatherManager: NSObject {

    let openWeatherURL:String! = nil
    
    func getWeatherForCity(city:String, completionWithWeatherArray: @escaping (_ weatherArray: Array<Any>?, _ error:NSError?) -> Void) {
        let url = NSURL(string:"http://api.openweathermap.org/data/2.5/forecast?q=\(city)&mode=json&appid=8afb80469c1d3ed26ae2cd3162b56c82&units=metric")
        
        getDataFromUrl(url: url as! URL) { (data, response, error)  in
            
            if(error == nil)
            {
                //parse facebook response
                let parsingManager = ParsingManager()
                parsingManager.parseWeatherForecast(responseData: data!, completionWithWeatherArray: {weatherArray, error in
                    completionWithWeatherArray(weatherArray!, error)
                })
            }
            else{
                completionWithWeatherArray(nil, NSError(domain: (error?.localizedDescription)!, code: 111, userInfo: nil))
            }
        }
}

    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
