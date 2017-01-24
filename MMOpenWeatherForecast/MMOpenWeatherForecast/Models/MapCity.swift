//
//  MapCity.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Sudhir Marathe on 24/01/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import UIKit
import MapKit

class MapCity: NSObject,MKAnnotation {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
