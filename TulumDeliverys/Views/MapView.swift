//
//  MapView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 12/06/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    // The map's state is controlled by SwiftUI properties
    @State private var position: MapCameraPosition = .automatic
    @State var viewmodel: MyViewModel

    var body: some View {
        Map(position: $position) {
            // Add markers and annotations declaratively
            Marker("Mexico City Zocalo",
                   coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332))
        }
    }
}
