//
//  GetWeatherForecastWebService.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Marathe on 1/20/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import Foundation

class GetWeatherForecastWebService: CommunicationServiceProtocol {

    // base URL
    let requestUrl = "http://api.openweathermap.org/data/2.5/weather?"
    
    var cityId: Int = -1;
    var weatherForecast : WeatherForecast?
    let responseHandler: WeatherForecastResponseHandler
    
    init(cityId: Int, responseHandler: @escaping WeatherForecastResponseHandler)
    {
        self.cityId = cityId
        self.responseHandler = responseHandler
    }
    
    // returns the requestUrl
    func getRequestURL() -> String
    {
        var weatherInfoURL : String = requestUrl;
        //Add city id
        weatherInfoURL += "\(REQUEST_KEY_CITY_ID)="
        weatherInfoURL += String(cityId);
        //Add App ID
        weatherInfoURL += "&\(REQUEST_KEY_APP_ID)=";
        weatherInfoURL += OPEN_WEATHER_MAP_APP_ID;
        
        return weatherInfoURL
    }
    
    // MARK: CommunicationServiceProtocol methods
    
    // handles the response
    func handleResponse(_ data:Data)
    {
        do{
            let jsonResult : [String:Any] = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as![String:Any]
            print("JSON response: \(jsonResult)");
            
            let weatherInfo : WeatherForecast =  self.parseResponse(jsonResult: jsonResult)
            responseHandler(weatherInfo, nil)
            
        }catch {
            print("Error with Json: \(error)")
            responseHandler(nil, error as NSError?)
        }
    }
    
    
    // handles the failure
    func handleFailure(_ error:NSError)
    {
        responseHandler(nil, error)
    }
    
    // returns the request body
    func getRequestBody() -> AnyObject?
    {
        return nil
    }
    
    // returns the Http headers
    func getHttpHeaders() -> NSDictionary?
    {
        return nil
    }
    
    // returns the Http Method
    func getHttpMethod() -> HTTP_METHOD
    {
        return HTTP_METHOD.GET
    }
    
    /*
     Parses the json response y
     parameters:
     1) jsonResult : [String:Any]
     Returns: WeatherForecast object
     */
    
    private func parseResponse(jsonResult : [String:Any]!) -> WeatherForecast
    {
        let weatherForecast : WeatherForecast = WeatherForecast()
        // parse weather main info
        if((jsonResult[RESPONSE_KEY_MAIN] as? NSDictionary) != nil)
        {
            let weatherMain = jsonResult[RESPONSE_KEY_MAIN] as! NSDictionary;
            
            //Parse Humidity
            if((weatherMain[RESPONSE_KEY_HUMIDITY] as? Double) != nil)
            {
                let humidity = weatherMain[RESPONSE_KEY_HUMIDITY] as! Double;
                weatherForecast.humidity = humidity;
            }
            
            //Parse pressure
            if((weatherMain[RESPONSE_KEY_PRESSURE] as? Double) != nil)
            {
                let pressure = weatherMain[RESPONSE_KEY_PRESSURE] as! Double;
                weatherForecast.pressure = pressure;
            }
            
            //Parse temperature
            if((weatherMain[RESPONSE_KEY_TEMP] as? Double) != nil)
            {
                let temperature = weatherMain[RESPONSE_KEY_TEMP] as! Double;
                weatherForecast.temperature = temperature;
            }
            
            //Parse max temperature
            if((weatherMain[RESPONSE_KEY_MAX_DAILY_TEMP] as? Double) != nil)
            {
                let maxTemperature = weatherMain[RESPONSE_KEY_MAX_DAILY_TEMP] as! Double;
                weatherForecast.temperatureMax = maxTemperature;
            }
            
            //Parse min temperature
            if((weatherMain[RESPONSE_KEY_MIN_DAILY_TEMP] as? Double) != nil)
            {
                let minTemperature = weatherMain[RESPONSE_KEY_MIN_DAILY_TEMP] as! Double;
                weatherForecast.temperatureMin = minTemperature;
            }
        }
        
        // parce city name
        if((jsonResult[RESPONSE_KEY_CITY_NAME] as? String) != nil)
        {
            let name = jsonResult[RESPONSE_KEY_CITY_NAME] as! String;
            weatherForecast.name = name;
        }
        
        // parce city id
        if((jsonResult[RESPONSE_KEY_CITY_ID] as? Int) != nil)
        {
            let cityId = jsonResult[RESPONSE_KEY_CITY_ID] as! Int;
            weatherForecast.cityId = cityId;
        }
        
        // parse co-ordinates
        if((jsonResult[RESPONSE_KEY_CITY_GEO_COORDINATES] as? NSDictionary) != nil)
        {
            let weatherCoords = jsonResult[RESPONSE_KEY_CITY_GEO_COORDINATES] as! NSDictionary;
            
            //Parse latitude
            if((weatherCoords[RESPONSE_KEY_LATITUDE] as? Double) != nil)
            {
                let latitude = weatherCoords[RESPONSE_KEY_LATITUDE] as! Double;
                weatherForecast.latitude = latitude;
            }
            
            //Parse longitude
            if((weatherCoords[RESPONSE_KEY_LONGITUDE] as? Double) != nil)
            {
                let longitude = weatherCoords[RESPONSE_KEY_LONGITUDE] as! Double;
                weatherForecast.longitude = longitude;
            }
        }
        
        // parse weather
        if((jsonResult[RESPONSE_KEY_WEATHER] as? [[String:Any]]) != nil)
        {
            let weatherDescription = jsonResult[RESPONSE_KEY_WEATHER] as! [[String:Any]]
            
            // parse weather description
            if((weatherDescription[0][RESPONSE_KEY_CONDITION_DESCRIPTION] as? String) != nil)
            {
                let weatherDescription = weatherDescription[0][RESPONSE_KEY_CONDITION_DESCRIPTION] as! String;
                weatherForecast.weatherDescription = weatherDescription;
            }
            
            // parse weather description main
            if((weatherDescription[0][RESPONSE_KEY_GROUP_PARAMETERS] as? String) != nil)
            {
                let weatherDescriptionMain = weatherDescription[0][RESPONSE_KEY_GROUP_PARAMETERS] as! String;
                weatherForecast.weatherDescriptionMain = weatherDescriptionMain;
            }
        }
        
        // parse cloud condition
        if((jsonResult[RESPONSE_KEY_CLOUDINESS] as? NSDictionary) != nil)
        {
            let cloudCondition = jsonResult[RESPONSE_KEY_CLOUDINESS] as! NSDictionary;
            
            // parse all
            if((cloudCondition[RESPONSE_KEY_ALL] as? Int) != nil)
            {
                let all = cloudCondition[RESPONSE_KEY_ALL] as! Int;
                weatherForecast.all = all;
            }
        }
        
        // parce date
        if((jsonResult[RESPONSE_KEY_WEATHER_DATE] as? TimeInterval) != nil)
        {
            let timeStamp = jsonResult[RESPONSE_KEY_WEATHER_DATE] as! TimeInterval;
            let date = Date(timeIntervalSince1970: timeStamp);
            weatherForecast.date = date;
        }
        
        // parce base
        if((jsonResult[RESPONSE_KEY_WEATHER_BASE] as? String) != nil)
        {
            let base = jsonResult[RESPONSE_KEY_WEATHER_BASE] as! String;
            weatherForecast.base = base;
        }
        
        // parse sys
        if((jsonResult[RESPONSE_KEY_WEATHER_SYS] as? NSDictionary) != nil)
        {
            let weatherSys = jsonResult[RESPONSE_KEY_WEATHER_SYS] as! NSDictionary;
            
            // parce country Name
            if((weatherSys[RESPONSE_KEY_COUNTRY] as? String) != nil)
            {
                let countryName = weatherSys[RESPONSE_KEY_COUNTRY] as! String;
                weatherForecast.countryName = countryName;
            }
            
            // parce country Id
            if((weatherSys[RESPONSE_KEY_COUNTRY_ID] as? Int) != nil)
            {
                let countryId = weatherSys[RESPONSE_KEY_COUNTRY_ID] as! Int;
                weatherForecast.countryId = countryId;
            }
            
            // parce message
            if((weatherSys[RESPONSE_KEY_MESSAGE] as? String) != nil)
            {
                let message = weatherSys[RESPONSE_KEY_MESSAGE] as! String;
                weatherForecast.message = message;
            }
            
            // parce sunrise
            if((weatherSys[RESPONSE_KEY_SUNRISE] as? TimeInterval) != nil)
            {
                let timeStamp = weatherSys[RESPONSE_KEY_SUNRISE] as! TimeInterval;
                let sunrise = Date(timeIntervalSince1970: timeStamp);
                weatherForecast.sunriseTime = sunrise;
            }
            
            // parce sunset
            if((weatherSys[RESPONSE_KEY_SUNSET] as? TimeInterval) != nil)
            {
                let timeStamp = weatherSys[RESPONSE_KEY_SUNSET] as! TimeInterval;
                let sunset = Date(timeIntervalSince1970: timeStamp);
                weatherForecast.sunsetTime = sunset;
            }
            
            // parce type
            if((weatherSys[RESPONSE_KEY_TYPE] as? Int) != nil)
            {
                let type = weatherSys[RESPONSE_KEY_TYPE] as! Int;
                weatherForecast.type = type;
            }
        }
        
        // parce code
        if((jsonResult[RESPONSE_KEY_INTERNAL_CODE] as? Int) != nil)
        {
            let cod = jsonResult[RESPONSE_KEY_INTERNAL_CODE] as! Int;
            weatherForecast.code = cod;
        }
        
        // parce visibility
        if((jsonResult[RESPONSE_KEY_INTERNAL_VISIBILITY] as? Int) != nil)
        {
            let visibility = jsonResult[RESPONSE_KEY_INTERNAL_VISIBILITY] as! Int;
            weatherForecast.visibility = visibility;
        }
        
        if((jsonResult[RESPONSE_KEY_WIND] as? NSDictionary) != nil)
        {
            let windInfo = jsonResult[RESPONSE_KEY_WIND] as! NSDictionary;
            
            //Parse degrees - windDirectionInDegrees
            if((windInfo[RESPONSE_KEY_WIND_DIRECTION_IN_DEGREES] as? Double) != nil)
            {
                let windDirectionInDegrees = windInfo[RESPONSE_KEY_WIND_DIRECTION_IN_DEGREES] as! Double;
                weatherForecast.windDirectionInDegrees = windDirectionInDegrees;
            }
            
            //Parse degrees - windDirectionInDegrees
            if((windInfo[RESPONSE_KEY_WIND_SPEED] as? Double) != nil)
            {
                let windSpeed = windInfo[RESPONSE_KEY_WIND_SPEED] as! Double;
                weatherForecast.windSpeed = windSpeed;
            }
        }
        
        return weatherForecast
    }
}
