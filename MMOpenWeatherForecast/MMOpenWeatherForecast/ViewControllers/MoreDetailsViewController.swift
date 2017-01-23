//
//  MoreDetailsViewController.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Marathe on 1/22/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import UIKit

class MoreDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var weatherInfo : WeatherForecast? = nil
    @IBOutlet weak var tableViewMoreDetails: UITableView!
    var weatherParameters: [String] = [WEATHER_DETAIL_KEY_WEATHER_CONDITION_DESCRIPTION,WEATHER_DETAIL_KEY_CLOUDINESS,WEATHER_DETAIL_KEY_WIND_SPEED,WEATHER_DETAIL_KEY_WIND_DIRECTION_IN_DEGREES,WEATHER_DETAIL_KEY_HUMIDITY,WEATHER_DETAIL_KEY_PRESSURE,WEATHER_DETAIL_KEY_TEMP, WEATHER_DETAIL_KEY_MIN_DAILY_TEMP, WEATHER_DETAIL_KEY_MAX_DAILY_TEMP];

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewMoreDetails.tableFooterView = UIView(frame: .zero)
        self.navigationController?.topViewController?.title = "More Weather Details"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style:.plain, target:nil, action:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getValueForWeatherParameter(_ weatherParameter: String) -> String
    {
        var weatherParameterValue: String = "";
        
        if(weatherParameter == WEATHER_DETAIL_KEY_WEATHER_CONDITION_DESCRIPTION)
        {
            weatherParameterValue = (weatherInfo?.weatherDescription)!
        }
        else if(weatherParameter == WEATHER_DETAIL_KEY_CLOUDINESS)
        {
            weatherParameterValue = String(format:"%.1f",(weatherInfo?.all)!);
            weatherParameterValue += "%";
        }
        else if(weatherParameter == WEATHER_DETAIL_KEY_WIND_SPEED)
        {
            weatherParameterValue = String(format:"%.1f",(weatherInfo?.windSpeed)!);
            weatherParameterValue += " m/sec";
        }
        else if(weatherParameter == WEATHER_DETAIL_KEY_WIND_DIRECTION_IN_DEGREES)
        {
            weatherParameterValue = String(format:"%.1f",(weatherInfo?.windDirectionInDegrees)!);
            weatherParameterValue += " degrees";
        }
        else if(weatherParameter == WEATHER_DETAIL_KEY_HUMIDITY)
        {
            weatherParameterValue = String(format:"%.1f",(weatherInfo?.humidity)!);
            weatherParameterValue += "%";
        }
        else if(weatherParameter == WEATHER_DETAIL_KEY_PRESSURE)
        {
            weatherParameterValue = String(format:"%.1f",(weatherInfo?.pressure)!);
            weatherParameterValue += " hPa";
        }
        else if(weatherParameter == WEATHER_DETAIL_KEY_TEMP)
        {
            //For Celsius
            weatherParameterValue = String(format: "%.0f °C", (weatherInfo?.temperature)! - 273.15)
        }
        else if(weatherParameter == WEATHER_DETAIL_KEY_MAX_DAILY_TEMP)
        {
            //For Celsius
            weatherParameterValue = String(format: "%.0f °C", (weatherInfo?.temperatureMax)! - 273.15)
        }
        else if(weatherParameter == WEATHER_DETAIL_KEY_MIN_DAILY_TEMP)
        {
            //For Celsius
            weatherParameterValue = String(format: "%.0f °C", (weatherInfo?.temperatureMin)! - 273.15)
        }
        return weatherParameterValue;
    }
    
    
    // MARK: UITablevieDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return weatherParameters.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let weatherParameter = weatherParameters[(indexPath as NSIndexPath).row];
    
        let cell = tableViewMoreDetails.dequeueReusableCell(withIdentifier: UI_TABLEVIEW_WEATHER_PARAMETER_CELL) ;
        cell!.textLabel?.text = weatherParameter;
        let weatherParameterValue = self.getValueForWeatherParameter(weatherParameter);
        cell!.detailTextLabel?.text = weatherParameterValue;
        
        cell!.selectionStyle = UITableViewCellSelectionStyle.none;
        cell!.accessoryType = UITableViewCellAccessoryType.none;
        
        return cell!;
    }
    
    // MARK: UITableView delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44;
    }
    
}
