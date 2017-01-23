//
//  WeatherForecastManager.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Marathe on 1/20/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import Foundation

/* Closure
 Sends the response to the WeatherForecastResponseUIHandler
 parameters: response : Any
 error : NSError
 */
typealias WeatherForecastResponseHandler = ((_ response : Any?, _ error : NSError?) -> Void)

class WeatherForecastManager {
    
    static let sharedInstance = WeatherForecastManager()
    
    
    fileprivate init() {
    }
    
    /* 
        Gets the weatherForecast for each City 
        parameters:
        1) cityID : Int
        2) responseUIHandler : WeatherForecastResponseUIHandler
     */
    func getWeatherForecast(_ cityId: Int, responseUIHandler : @escaping WeatherForecastResponseUIHandler)
    {
        let responseHandler: WeatherForecastResponseHandler =  { (response: Any?, error: NSError?) in
            responseUIHandler(response, error)
        }
        
        let weatherForecastWebservice = GetWeatherForecastWebService(cityId: cityId, responseHandler: responseHandler)
        
        let httpCommunication = HttpCommunication.sharedInstance
        
        let requestUrlStr : String = weatherForecastWebservice.getRequestURL()
        
        let method = weatherForecastWebservice.getHttpMethod()
        
        httpCommunication.executeRequest(weatherForecastWebservice, requestUrlStr: requestUrlStr, requestType: method)
    }
}
