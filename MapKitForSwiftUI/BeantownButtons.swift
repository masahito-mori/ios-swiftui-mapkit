//
//  BeantownButtons.swift
//  MapKitForSwiftUI
//
//  Created by 森匡人 on 2023/10/21.
//

import SwiftUI
import MapKit

struct BeantownButtons: View {
    @Binding var position: MapCameraPosition
    
    @Binding var searchResults : [MKMapItem]
    
    var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        HStack {
            Button {
                search(for: "playground")
            } label: {
                Label("Playgrounds", systemImage: "figure.and.child.holdinghands")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                search(for: "beach")
            } label: {
                Label("Beaches", systemImage: "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                position = .region(.boston)
            } label: {
                Label("Boston", systemImage: "building.2")
            }
            
            Button {
                position = .region(.northShore)
            } label: {
                Label("North Shore", systemImage: "water.waves")
            }
        }
        .labelStyle(.iconOnly)
    }
    
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .parking,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125)
        )
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
}
