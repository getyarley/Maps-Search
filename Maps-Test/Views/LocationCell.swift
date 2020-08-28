//
//  LocationCell.swift
//  Maps-Test
//
//  Created by Jeremy Yarley on 8/25/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationCell: View {
    var location: MKPointAnnotation
    
    var body: some View {
        VStack(alignment: .leading) {
                        
            HStack {
                Spacer()
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .frame(width: 20, height: 25)
                    .foregroundColor(.gray)
                Spacer()
            }.padding(.top, 15)
                        
            Group{
                Text(String(location.title ?? "Unknown"))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                
                Text(String(location.subtitle ?? "Unkown"))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
            }
            
            Spacer()
        }
        .background(Color.white)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 4)
        .frame(width: 150, height: 150)
    }
}

struct LocationCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationCell(location: MKPointAnnotation())
    }
}
