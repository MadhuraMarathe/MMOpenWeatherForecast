//
//  WeatherDetailsViewController.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Marathe on 1/22/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import UIKit

class WeatherDetailsViewController: UIViewController {
    
    var weatherInfo : WeatherForecast? = nil
    
    let CLOUDY_WEATHER = "Cloudy"
    let CLEAR_WEATHER = "Clear"
    let RAINY_WEATHER = "Rainy"
    let CLEAR_BACKGROUND_IMAGE = "ClearBackground"
    let CLOUDY_BACKGROUND_IMAGE = "CloudsBackground"
    let RAINY_BACKGROUND_IMAGE = "RainBackground"

    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var imageCurrentWeatherIcon: UIImageView!
    
    
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var labelCurrentWeather: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpUI()
    {        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        
        
        if weatherInfo?.name == "Melbourne" || weatherInfo?.name == "Sydney"
        {
            dateFormatter.timeZone = TimeZone(identifier: "GMT+11")
        }
        else
        if weatherInfo?.name == "Brisbane"
        {
            dateFormatter.timeZone = TimeZone(identifier: "GMT+10")
        }

        let dateString = dateFormatter.string(from: (weatherInfo?.date)!)
        
        labelDate.text = dateString
        labelTemperature.text = String(format: "%.0f °C", (weatherInfo?.temperature)! - 273.15)
        labelCityName.text = weatherInfo?.name
        
        let isCloudy = weatherInfo?.weatherDescriptionMain == "Clouds"
        let isClear = weatherInfo?.weatherDescriptionMain == "Clear"
        let isRainy = weatherInfo?.weatherDescriptionMain == "Rain"
        
        if isCloudy == true
        {
            labelCurrentWeather.text = CLOUDY_WEATHER
            imageBackground.image = UIImage(named: CLOUDY_BACKGROUND_IMAGE)
            imageCurrentWeatherIcon.image = UIImage(named: CLOUDY_WEATHER)
        }
        else
        if isClear == true
        {
            labelCurrentWeather.text = CLEAR_WEATHER
            imageBackground.image = UIImage(named: CLEAR_BACKGROUND_IMAGE)
            imageCurrentWeatherIcon.image = UIImage(named: CLEAR_WEATHER)
        }
        else
        if isRainy == true
        {
            labelCurrentWeather.text = RAINY_WEATHER
            imageBackground.image = UIImage(named: RAINY_BACKGROUND_IMAGE)
            imageCurrentWeatherIcon.image = UIImage(named: RAINY_WEATHER)
        }
    }
    
    // MARK: IBAction
    @IBAction func btnMorePressed(_ sender: AnyObject)
    {
        let weatherMoreDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: UI_MORE_WEATHER_DETAILSVC) as? MoreDetailsViewController
        
        weatherMoreDetailsVC?.weatherInfo = weatherInfo
        
        self.navigationController?.show(weatherMoreDetailsVC!, sender: self)
    }

}
