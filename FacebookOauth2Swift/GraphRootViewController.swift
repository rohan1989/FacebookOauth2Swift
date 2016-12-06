//
//  GraphRootViewController.swift
//  FacebookOauth2Swift
//
//  Created by Rohan Sonawane on 06/12/16.
//  Copyright © 2016 Rohan Sonawane. All rights reserved.
//

import UIKit

struct GraphRootViewControllerConstants {
    static let graphSegueIdentifier = "showGraphView"
}

class GraphRootViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterCityTextField: UITextField!
    
    var weatherArray:Array<WeatherForecast>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.enterCityTextField.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    private func showWeatherGraph(){
        self.performSegue(withIdentifier: GraphRootViewControllerConstants.graphSegueIdentifier, sender: nil)
    }
    
    @IBAction func showWeatherButtonAction(_ sender: Any) {
        
        if enterCityTextField.text?.characters.count == 0 {return}
        
        let openWeatherManager:OpenWeatherManager = OpenWeatherManager()
        openWeatherManager.getWeatherForCity(city: enterCityTextField.text!, completionWithWeatherArray: {weatherArray, error in
            DispatchQueue.main.async() { () -> Void in
                
                if((error?.code) != 111){
                    self.weatherArray = weatherArray as? Array<WeatherForecast>
                    self.showWeatherGraph()
                }
                else{
                    self.showAlert(title: "Error Occurred", message: (error?.localizedDescription)!)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if GraphRootViewControllerConstants.graphSegueIdentifier == segue.identifier {
            let destinationViewController = segue.destination as! GraphViewController
            destinationViewController.weatherArray = self.weatherArray
            destinationViewController.city = enterCityTextField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
