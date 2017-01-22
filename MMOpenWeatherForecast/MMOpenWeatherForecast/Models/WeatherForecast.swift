//
//  ListTemperatures.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Marathe on 1/20/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import Foundation

class WeatherForecast: NSObject {
    
    // main
    var humidity: Double = -1;
    var pressure: Double = -1;
    var temperature: Double = 0.0
    var temperatureMax: Double = -1
    var temperatureMin: Double = -1
    
    // name
    var name: String = ""
    var cityId : Int = -1
    
    // co-ordinates
    var latitude : Double = -1
    var longitude : Double = -1
    
    // weather description
    var weatherDescription : String = ""
    var weatherDescriptionMain : String = ""
    
    // clouds
    var all : Int = -1
    
    // Date
    var date = Date();
    
    // base
    var base : String = ""
    
    // Sys 
    var countryName : String = ""
    var countryId : Int = -1
    var message : String = ""
    var sunriseTime = Date()
    var sunsetTime = Date()
    var type : Int = -1
    
    // cod
    var code : Int = -1
    
    // visibility
    var visibility : Int = -1
    
    // wind description
    var windSpeed = 0.0
    var windDirectionInDegrees = 0.0
}
