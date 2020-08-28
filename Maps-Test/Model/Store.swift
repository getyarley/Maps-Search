//
//  Store.swift
//  Maps-Test
//
//  Created by Jeremy Yarley on 8/25/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

final class Store: ObservableObject {
    
    @Published var currentCoordinates = coords.acadia //Starting coordinates
    @Published var locations = [MKPointAnnotation]()
    @Published var tempLocation: MKPointAnnotation?
    
    
    init() {
        initAnnotations(coordinates: coords.acadia)
        initAnnotations(coordinates: coords.yosemite)
    }
    
    
    func initAnnotations(coordinates: CLLocationCoordinate2D) {
        getLocationInfo(coords: coordinates) { (placemark) in
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            if let name = placemark?.name {
                annotation.title = name
            }
            
            if let city = placemark?.locality, let state = placemark?.administrativeArea {
                annotation.subtitle = city + ", " + state
            }
            
            self.locations.append(annotation)
            self.currentCoordinates = coordinates
        }
    }
    
    
    func addAnnotation(coordinates: CLLocationCoordinate2D) {
        getLocationInfo(coords: coordinates) { (placemark) in
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            if let name = placemark?.name {
                annotation.title = name
            }
            
            if let city = placemark?.locality, let state = placemark?.administrativeArea {
                annotation.subtitle = city + ", " + state
            }
            
            self.tempLocation = annotation
            self.currentCoordinates = coordinates
        }
    }
    
    
    
    
    
    func getLocationInfo(coords: CLLocationCoordinate2D, completionHandler: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        
        //Look up location based on coordinates
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completionHandler(nil)
            } else {
                guard let placemark = placemarks?.first else {
                    print("Doesn't exist")
                    completionHandler(nil)
                    return
                }
                completionHandler(placemark)
            }
        })
        
    } //END OF FUNC
}


