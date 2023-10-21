//
//  ContentView.swift
//  MapKitForSwiftUI
//
//  Created by 森匡人 on 2023/10/21.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let parking = CLLocationCoordinate2D(latitude: 42.354528, longitude: -71.068369)
}

extension MKCoordinateRegion {
    static let boston = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.360256, longitude: -71.057279),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    static let northShore = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.547608, longitude: -70.870085),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
}

struct ContentView: View {
    
    @State private var position: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    
    @State private var searchResults: [MKMapItem] = []
    
    var body: some View {
        Map(position: $position) {
            Annotation("Parking", coordinate: .parking) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.background)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.secondary, lineWidth: 5)
                    Image(systemName: "car")
                        .padding(5)
                }
            }
            .annotationTitles(.hidden)
            
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
            }
            
        }
        .mapStyle(.standard(elevation: .realistic))
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                BeantownButtons(position: $position, searchResults: $searchResults, visibleRegion: visibleRegion)
                    .padding(.top)
                Spacer()
            }
            .background()
        }
        .onChange(of: searchResults) {
            position = .automatic
        }
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
    }
}

#Preview {
    ContentView()
}
