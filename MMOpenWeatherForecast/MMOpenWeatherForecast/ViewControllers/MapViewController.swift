//
//  MapViewController.swift
//  MMOpenWeatherForecast
//
//  Created by Madhura Sudhir Marathe on 24/01/17.
//  Copyright © 2017 Madhura. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var cityTemperaturesArray : [CityTemperatures] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapView.showsUserLocation = true
        mapView.delegate = self
        self.setUpUI()
    }

    func setUpUI()
    {
        let annotations = getMapAnnotations()
        // Add mappoints to Map
        mapView.addAnnotations(annotations)
        
        mapView.showAnnotations(mapView.annotations, animated: true)
        mapView.showsPointsOfInterest = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMapAnnotations() -> [MapCity]
    {
        var annotations:Array = [MapCity]()

        //iterate and create annotations
        for items in cityTemperaturesArray
        {
            let cityTemperature = items as CityTemperatures
            var lat = 0.0
            var long = 0.0
            // lat, longs received from webservice are wrong
            if cityTemperature.weatherInfo.name == "Melbourne"
            {
                lat = -37.8136
                long = 144.9631
            }
            else
            {
                lat = cityTemperature.weatherInfo.latitude
                long = cityTemperature.weatherInfo.longitude
            }
            
            let annotation = MapCity(latitude: lat, longitude: long)
            annotation.title = cityTemperature.weatherInfo.name
            annotations.append(annotation)
        }
        
        return annotations
    }
    
    // MARK: IBActions
   
    @IBAction func changeMapTypeAction(_ sender: Any)
    {
        if mapView.mapType == MKMapType.standard {
            mapView.mapType = MKMapType.satellite
        } else {
            mapView.mapType = MKMapType.standard
        }
    }
    
    // MARK : MapView delegate methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        mapView.centerCoordinate = (userLocation.location?.coordinate)!
    }
}

