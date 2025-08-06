//
//  ContentView.swift
//  MapAnnotations_SwiftUI
//
//  Created by Palla Kumar on  06/08/25.
//

import SwiftUI
import MapKit

enum TransportMode: String, CaseIterable, Hashable {
    case driving
    case walking
    case transit

    var mapKitType: MKDirectionsTransportType {
        switch self {
        case .driving: return .automobile
        case .walking: return .walking
        case .transit: return .transit
        }
    }

    var emoji: String {
        switch self {
        case .driving: return "🚗"
        case .walking: return "🚶‍♂️"
        case .transit: return "🚌"
        }
    }
}


struct ContentView: View {
    @State private var source = ""
    @State private var destination = ""
    @State private var travelMode: TransportMode = .driving

    @State private var refreshTrigger = UUID()
    @State private var routeDistance: String = ""
    @State private var routeTime: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Maps")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.indigo)
                .padding(.top)
            TextField("Enter Source", text: $source)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Enter Destination", text: $destination)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Picker("Travel Mode", selection: $travelMode) {
                ForEach(TransportMode.allCases, id: \.self) { mode in
                    Text("\(mode.emoji) \(mode.rawValue.capitalized)").tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            if !source.isEmpty && !destination.isEmpty {
                VStack(spacing: 10) {
                    RouteMapView(
                        source: source,
                        destination: destination,
                        transportType: travelMode.mapKitType,
                        trigger: refreshTrigger
                    ) { distance, time in
                        self.routeDistance = distance
                        self.routeTime = time
                    }
                    .frame(height: 350)
                    .cornerRadius(12)
                    .shadow(radius: 5)

                    InfoCard(title: "Distance", value: routeDistance, icon: "map")
                    InfoCard(title: "ETA", value: routeTime, icon: "clock")
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)

        // 🔁 Auto-update on any change
        .onChange(of: source) { _ in refreshTrigger = UUID() }
        .onChange(of: destination) { _ in refreshTrigger = UUID() }
        .onChange(of: travelMode) { _ in refreshTrigger = UUID() }
    }
}

