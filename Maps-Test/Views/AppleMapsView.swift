//
//  AppleMapsView.swift
//  Maps-Test
//
//  Created by Jeremy Yarley on 8/25/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import SwiftUI
import MapKit

struct AppleMapsView: UIViewRepresentable {
    
    var coordinate: CLLocationCoordinate2D
    var annotations: [MKPointAnnotation]
    var tempAnnotation: MKPointAnnotation?
    
    var addLocation: ((MKPointAnnotation) -> Void)
    
    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator
        
        return mkMapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        //Update annotations
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
        
        //Temp annotation
        if let tempAnnotation = tempAnnotation {
            view.addAnnotation(tempAnnotation)
        } else {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    //MARK: Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: AppleMapsView
        
        init(_ parent: AppleMapsView) {
            self.parent = parent
        }
        
        
        //Custom Annotation
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "placemark" //Reuse identifier
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                //Make a new view, expensive
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true //Allows this to show popup info
                annotationView?.rightCalloutAccessoryView = UIButton(type: .contactAdd) //The + add button
//                annotationView?.detailCalloutAccessoryView = UIImageView(image: UIImage(systemName: "map"))
            } else {
                annotationView?.annotation = annotation //Reuse the existing one
            }
            
            return annotationView
        }
        
        
        //"i" information button pressed
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? MKPointAnnotation else {return}
            
            parent.addLocation(placemark)
        }
        
    } //END OF COORDINATOR
    
}

struct AppleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMapsView(coordinate: CLLocationCoordinate2D(latitude: -116.166868, longitude: 34.011286), annotations: [], addLocation: {_ in })
    }
}
