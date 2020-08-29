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
                annotationView?.rightCalloutAccessoryView = UIButton(type: .contactAdd) //The + add button, use this for the default accessory button
            } else {
                annotationView?.annotation = annotation //Reuse the existing one
            }
            
            return annotationView
        }
        
        //Use this for the default accessory button
        //Add + information button pressed
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? MKPointAnnotation else {return}

            parent.addLocation(placemark)
        }
        
        
        //Set up custom MKAnnotationView
//        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//            configureDetailView(annotationView: view)
//        }
//
//        //Make custom Annotation View with buttons
//        func configureDetailView(annotationView: MKAnnotationView) {
//            let height = 35
//            let width = 200
//            let buttonHeight = 35
//
//            let containerView = UIView()
//            let views = ["containerView": containerView]
//            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[containerView(\(width))]", options: [], metrics: nil, views: views))
//            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[containerView(\(height))]", options: [], metrics: nil, views: views))
//
//            //Add Button
//            let addButton = UIButton(frame: CGRect(x: 5, y: height-buttonHeight, width: width/2 - 10, height: buttonHeight))
//            addButton.setTitle("Add", for: .normal)
//            addButton.tintColor = UIColor.white
//            addButton.backgroundColor = UIColor.blue
//            addButton.layer.cornerRadius = 8
//            addButton.addTarget(self, action: #selector(addLocation), for: .touchDown)
//
//            //Delete Button
//            let deleteButton = UIButton(frame: CGRect(x: width/2 + 5, y: height-buttonHeight, width: width/2 - 10, height: buttonHeight))
//            deleteButton.setTitle("Delete", for: .normal)
//            deleteButton.tintColor = UIColor.white
//            deleteButton.backgroundColor = UIColor.red
//            deleteButton.layer.cornerRadius = 8
//            deleteButton.addTarget(self, action: #selector(deleteLocation), for: .touchDown)
//
//
//            containerView.addSubview(addButton)
//            containerView.addSubview(deleteButton)
//            annotationView.detailCalloutAccessoryView = containerView
//        }
//
//
//        //Add Button function
//        @objc func addLocation() {
//            if parent.tempAnnotation == nil {print("Temp annotation = nil")}
//
//            if let annotation = parent.tempAnnotation {
//                checkForAnnotation(annotation: annotation)
//                parent.addLocation(annotation)
//            } else {
//                print("Annotation error")
//            }
//        }
//
//        //Delete Button function
//        @objc func deleteLocation() {
//            print("Delete Location")
//        }
//
//
//        func checkForAnnotation(annotation: MKPointAnnotation) {
//            print("Checking...")
//            if let index = parent.annotations.firstIndex(of: annotation) {
//                print("Annotation found at: \(index)")
//            } else {
//                print("Annotation not found")
//            }
//        }
        
    } //END OF COORDINATOR
    
}

struct AppleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMapsView(coordinate: CLLocationCoordinate2D(latitude: -116.166868, longitude: 34.011286), annotations: [], addLocation: {_ in })
    }
}

