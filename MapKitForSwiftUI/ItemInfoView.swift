//
//  ItemInfoView.swift
//  MapKitForSwiftUI
//
//  Created by 森匡人 on 2023/10/21.
//

import SwiftUI
import MapKit

struct ItemInfoView: View {
    @State private var lookAroundScene: MKLookAroundScene?
    
    let selectedResult: MKMapItem
    let route: MKRoute?
    
    private var travelTime: String? {
        guard let route else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: route.expectedTravelTime)
    }
    
    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Text("\(selectedResult.name ?? "")")
                    if let travelTime {
                        Text(travelTime)
                    }
                }
                .font(.caption)
                .foregroundColor(.white)
                .padding(10)
            }
            .onAppear() {
                getLookAroundScene()
            }
            .onChange(of: selectedResult) {
                getLookAroundScene()
            }
    }
    
    func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: selectedResult)
            lookAroundScene = try? await request.scene
        }
    }
}
