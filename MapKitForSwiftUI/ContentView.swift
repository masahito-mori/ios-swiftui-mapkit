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
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    
    var body: some View {
        Map(position: $position, selection: $selectedResult) {
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
            .annotationTitles(.hidden)
            
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
            
        }
        .mapStyle(.standard(elevation: .realistic))
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                VStack(spacing: 0) {
                    if let selectedResult {
                        ItemInfoView(selectedResult: selectedResult, route: route)
                            .frame(height: 128)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.top, .horizontal])
                    }
                    BeantownButtons(position: $position, searchResults: $searchResults, visibleRegion: visibleRegion)
                        .padding(.top)
                }
                Spacer()
            }
            .background()
        }
        .onChange(of: searchResults) {
            position = .automatic
        }
        .onChange(of: selectedResult) {
            getDirections()
        }
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
    }
    
    func getDirections() {
        route = nil
        guard let selectedResult else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .parking))
        request.destination = selectedResult
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
}

#Preview {
    ContentView()
}
