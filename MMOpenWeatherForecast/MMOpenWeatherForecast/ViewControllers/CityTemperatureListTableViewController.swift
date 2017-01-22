//
//  CityTemperatureListTableViewController.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Marathe on 1/20/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import SwiftOverlays
import UIKit

// closure which gets called when response is received by the manager layer
typealias WeatherForecastResponseUIHandler = ((_ response : Any?, _ error : NSError?) -> Void)

class CityTemperatureListTableViewController: UITableViewController {
    @IBOutlet var tableViewTemperatureList: UITableView!
    var cityTemperaturesArray : [CityTemperatures] = []
    var cityNames : [String] = ["Melbourne","Brisbane","Sydney"]
    var cityIDs: [Int] = [4163971,2174003,2147714]
    
    var dataAvailabilityStatusDict : NSMutableDictionary = ["Melbourne" : -1, "Brisbane" : -1, "Sydney" : -1]
    
    let CITY_COUNT = 3
    
    var bShouldUpdateUI = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func updateDatasource( weatherInfo : WeatherForecast) {
        
        for i in 0 ..< self.CITY_COUNT
        {
            let cityDetails = cityTemperaturesArray[i]
            
            if cityDetails.cityId == weatherInfo.cityId
            {
                // fill only necessary data for listing the temperatures in CityTemperatures object
                cityDetails.cityTemperature = weatherInfo.temperature
                
                // full weatherInfo object will be needed only to see the detail information on the next screen
                cityDetails.weatherInfo = weatherInfo
                cityTemperaturesArray[i] = cityDetails
            }
        }
    }
    
    func setUpUI()
    {
        self.tableViewTemperatureList.tableFooterView = UIView(frame: .zero)
        dataAvailabilityStatusDict = ["Melbourne" : -1, "Brisbane" : -1, "Sydney" : -1]
        // create array of CityTemperatures
        
        let responseUIHandler : WeatherForecastResponseUIHandler = { (response: Any?, error: NSError?) in
            
            if error != nil
            {
                DispatchQueue.main.async{
                    
                    var errorDescription: String? = error?.localizedDescription
                    if(errorDescription == nil)
                    {
                        errorDescription = "Error in fetching weather information. Try again Later."
                    }
                    let alert = UIAlertController(title: "Error",
                                                  message: errorDescription,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    // remove activity indicator
                    SwiftOverlays.removeAllOverlaysFromView(self.view)
                    self.view.alpha = 1
                }
            }
            else
            {
                let weatherInfo : WeatherForecast = (response as? WeatherForecast)!
                self.updateDatasource(weatherInfo: weatherInfo)
                self.dataAvailabilityStatusDict.setValue(1, forKey: weatherInfo.name)
                
                for (_, value) in self.dataAvailabilityStatusDict
                {
                    let isEqual = (value as! Int == 1)
                    
                    if isEqual == false
                    {
                        self.bShouldUpdateUI = false
                        break;
                    }
                    else
                    {
                        self.bShouldUpdateUI = true
                    }
                }
                
                if self.bShouldUpdateUI == true
                {
                    DispatchQueue.main.async {
                        // remove activity indicator
                        SwiftOverlays.removeAllOverlaysFromView(self.view)
                        self.view.alpha = 1
                        self.tableViewTemperatureList.reloadData()
                    }
                }
            }
        }
        
        // show activity indicator
        self.view.alpha = 0.5
        SwiftOverlays.showCenteredWaitOverlayWithText(self.view, text: "Please wait...")
        
        for i in 0 ..< CITY_COUNT
        {
            let cityTemperature : CityTemperatures = CityTemperatures()
            cityTemperature.cityName = cityNames[i]
            cityTemperature.cityId = cityIDs[i]
            cityTemperaturesArray.append(cityTemperature)
            
            // call GetWeatherForecastService
            WeatherForecastManager.sharedInstance.getWeatherForecast(cityIDs[i], responseUIHandler: responseUIHandler)
        }
    }
    
    // MARK: UITableViewDataSourece
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cityTemperaturesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let listDetailsCell = tableView.dequeueReusableCell(withIdentifier: UITABLEVIEWLISTCELL, for: indexPath) as! ListDetailsTableViewCell
        
        let cityTemperature = cityTemperaturesArray[(indexPath as NSIndexPath).row]
        
        listDetailsCell.labelCityName.text = cityTemperature.cityName
        
        if cityTemperature.cityTemperature > 0
        {
            listDetailsCell.labelTemperature.isHidden = false
            listDetailsCell.labelTemperature.text = String(format: "%.0f °C", cityTemperature.cityTemperature - 273.15)
            // to show in Kelvin
//            String(cityTemperature.cityTemperature) + "K"
        }
        else
        {
            listDetailsCell.labelTemperature.isHidden = true
        }
        listDetailsCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return listDetailsCell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let weatherForecast = cityTemperaturesArray[indexPath.row]
        
        let weatherDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: UIWEATHERDETAILSVC) as? WeatherDetailsViewController
        
        weatherDetailsVC?.weatherInfo = weatherForecast.weatherInfo
        
        self.navigationController?.show(weatherDetailsVC!, sender: self)
    }
}
