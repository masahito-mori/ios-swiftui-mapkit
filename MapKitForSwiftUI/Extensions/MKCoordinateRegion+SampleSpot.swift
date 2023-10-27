//
//  MKCoordinateRegion+SampleSpot.swift
//  MapKitForSwiftUI
//
//  Created by 森匡人 on 2023/10/27.
//

import MapKit

extension MKCoordinateRegion {
    static let boston = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.360256, longitude: -71.057279),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    static let northShore = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.547608, longitude: -70.870085),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
}
