//
//  CommunicationServiceProtocol.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Marathe on 1/20/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import Foundation

protocol CommunicationServiceProtocol {
    
    func getRequestURL() -> String
    func handleResponse(_ data:Data)
    func handleFailure(_ error:NSError)
    func getHttpMethod() -> HTTP_METHOD
    
    
    func getRequestBody() -> AnyObject?
    func getHttpHeaders() -> NSDictionary? // marked as optional as not all requests may have headers and request bodies
    
    
}
