//
//  HttpCommunication.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Marathe on 1/20/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import Foundation

enum HTTP_METHOD : String
{
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

enum HTTP_RESPONSE_CODES : Int
{
    case success = 200
    case bad_REQUEST = 400
    case not_FOUND = 404
}

class HttpCommunication: NSObject {

    static let sharedInstance = HttpCommunication()
    
    fileprivate override init() {
        
    }
    
    func executeRequest(_ service : CommunicationServiceProtocol, requestUrlStr : String, requestType : HTTP_METHOD)
    {
        let requestURL : URL = URL(string: requestUrlStr)!
        var urlRequest  = URLRequest(url: requestURL)
        urlRequest.httpMethod = String(describing: requestType)
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        print("Request URL : \(requestURL)\n")
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {

            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if(error != nil)
            {
                print("Request Failure!")
                service.handleFailure(error! as NSError)
            }
            else if (response == nil)
            {
                let userInfo: [AnyHashable : Any]? =
                    [
                        NSLocalizedDescriptionKey :  NSLocalizedString("Error", value: "Unknown error encountered", comment: "")
                    ]
                let err: NSError = NSError(domain: "", code: -1, userInfo: userInfo)
                print("Request Failure!")
                service.handleFailure(err)
            }
            else
            {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == HTTP_RESPONSE_CODES.success.rawValue)
                {
                    if(data == nil)
                    {
                        let userInfo: [AnyHashable : Any]? =
                            [
                                NSLocalizedDescriptionKey :  NSLocalizedString("Error", value: "No response data received", comment: "")
                            ]
                        let err: NSError = NSError(domain: "", code: -1, userInfo: userInfo)
                        print("Request Failure!")
                        service.handleFailure(err)
                    }
                    else
                    {
                        print("Request Success!")
                        service.handleResponse(data!)
                    }
                }
                else
                {
                    print("Request Failure!")
                    service.handleFailure(error! as NSError)
                }
            }
        }
        
        task.resume()
    }
}
