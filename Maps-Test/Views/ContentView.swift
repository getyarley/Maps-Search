//
//  ContentView.swift
//  Maps-Test
//
//  Created by Jeremy Yarley on 8/25/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

enum AlertType {
    case added, duplicate, delete, error
}

struct ContentView: View {
    
    @EnvironmentObject var store: Store
    
    @State var searchAddress: String = ""
    @State var selectedPlace: MKPointAnnotation?
    @State var showAlert = false
    @State var alertType: AlertType = .added
    @State var editingSearch = false
    @State private var deleteIndex = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center) {
                AppleMapsView(coordinate: store.currentCoordinates, annotations: store.locations, tempAnnotation: self.store.tempLocation, addLocation: self.addLocation)
                    .edgesIgnoringSafeArea(.all)
            } //END OF VSTACK
            
            VStack {
                Spacer()
                
                if !self.store.locations.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(self.store.locations, id: \.self) { location in
                                ZStack(alignment: .topTrailing) {
                                    Button(action: {self.moveToPin(location: location)}) {
                                        LocationCell(location: location)
                                    }.buttonStyle(PlainButtonStyle())
                                    
                                    Button(action: {self.requestDeleteLocation(location: location)}) {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.gray)
                                            .padding(8)
                                    }
                                    
                                } //END OF ZSTACK
                            }.padding(8)
                        }
                    }.padding(.horizontal, 4)
                        .padding(.bottom, 30)
                }
            } //END OF VSTACK
            
            Group{
                HStack {
                    TextField("Search...", text: self.$searchAddress, onEditingChanged: {edit in
                        if !self.searchAddress.isEmpty {
                            self.editingSearch = true
                        }
                    })
                    
                    if self.editingSearch {
                        Button(action: {
                            self.searchAddress = ""
                            self.editingSearch = false
                        }) {
                            Text("X")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Button(action: {self.searchForAddress()}) {
                        Text("Go")
                    }
                }.padding()
            } //END OF GROUP
            .background(Color.white)
            .mask(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
        } //END OF Z
        //Show details from pin
            
        .alert(isPresented: $showAlert) {
            switch alertType {
                case .added: return Alert(title: Text("Location Added!"), message: Text(selectedPlace?.title ?? "Title Not Found"), dismissButton: .default(Text("Ok")))
                case .duplicate: return Alert(title: Text("Location Already Exists"), dismissButton: .default(Text("Ok")))
            case .delete: return Alert(title: Text("Are you sure you want to delete?"), primaryButton: .destructive(Text("Delete")){
                self.store.locations.remove(at: self.deleteIndex)
                print("Deleted")
                }, secondaryButton: .cancel())
            case .error: return Alert(title: Text("There was an Error"), dismissButton: .default(Text("Ok")))
            }
        } //END OF ALERT
            
    }
    
    //Search for Address
    func searchForAddress() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.searchAddress) { (placemarks, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            } else {
                guard let placemarks = placemarks, let location = placemarks.first, let coords = location.location else {
                    return
                }
                
                self.store.addAnnotation(coordinates: coords.coordinate)
                return
            }
        }
    }
    
    //Move to Pin
    func moveToPin(location: MKPointAnnotation) {
        self.store.currentCoordinates = location.coordinate
    }
    
    //Add location
    func addLocation(location: MKPointAnnotation) {
        if let _ = store.locations.firstIndex(of: location) {
            showAlert = true
            alertType = .duplicate
        } else {
            self.store.locations.append(location)
            self.store.tempLocation = nil
            selectedPlace = location
            showAlert = true
            alertType = .added
        }
    }
    
    //Delete Location
    func requestDeleteLocation(location: MKPointAnnotation) {
        if let index = store.locations.firstIndex(of: location) {
            deleteIndex = index
            showAlert = true
            alertType = .delete
        } else {
            showAlert = true
            alertType = .error
        }
    }
    
    func confirmDeleteLocation() {
//        if self.selectedPlace ==
        self.store.locations.remove(at: self.deleteIndex)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct coords {
    static let acadia = CLLocationCoordinate2D(latitude: 44.3386, longitude: -68.2733)
    static let yosemite = CLLocationCoordinate2D(latitude: 37.8651, longitude: -119.5383)
}
