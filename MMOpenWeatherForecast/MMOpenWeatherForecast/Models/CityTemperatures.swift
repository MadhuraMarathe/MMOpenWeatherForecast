//
//  CityTemperatures.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Marathe on 1/20/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import Foundation

class CityTemperatures: NSObject {
    /* city Name */
    var cityName : String = ""
    
    /* city Temperature */
    var cityTemperature : Double = 0.0
    
    /* city Id */
    var cityId : Int = -1
    
    var weatherInfo : WeatherForecast = WeatherForecast()
}
