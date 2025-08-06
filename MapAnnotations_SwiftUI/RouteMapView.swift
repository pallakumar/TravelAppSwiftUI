//
//  RouteMapView.swift
//  MapAnnotations_SwiftUI
//
//  Created by Palla Kumar on  06/08/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct RouteMapView: UIViewRepresentable {
    let source: String
    let destination: String
    let transportType: MKDirectionsTransportType
    let trigger: UUID // Add this!
    let onRouteInfoUpdate: (String, String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        context.coordinator.parent = self // update latest values
        context.coordinator.requestRoute(mapView: uiView)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RouteMapView
        let geocoder = CLGeocoder()

        init(_ parent: RouteMapView) {
            self.parent = parent
        }

        func requestRoute(mapView: MKMapView) {
            guard !parent.source.isEmpty, !parent.destination.isEmpty else { return }

            geocoder.geocodeAddressString(parent.source) { sourcePlacemarks, _ in
                guard let sourceLocation = sourcePlacemarks?.first?.location else { return }

                self.geocoder.geocodeAddressString(self.parent.destination) { destinationPlacemarks, _ in
                    guard let destinationLocation = destinationPlacemarks?.first?.location else { return }

                    let request = MKDirections.Request()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceLocation.coordinate))
                    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation.coordinate))
                    request.transportType = self.parent.transportType
                    request.requestsAlternateRoutes = true

                    let directions = MKDirections(request: request)
                    directions.calculate { response, error in
                        guard let response = response else { return }

                        mapView.removeOverlays(mapView.overlays)

                        for route in response.routes {
                            mapView.addOverlay(route.polyline)
                        }

                        if let mainRoute = response.routes.first {
                            let distanceKm = String(format: "%.2f km", mainRoute.distance / 1000)
                            let minutes = Int(mainRoute.expectedTravelTime / 60)
                            let timeStr = minutes < 60 ? "\(minutes)m" : "\(minutes / 60)h \(minutes % 60)m"

                            self.parent.onRouteInfoUpdate(distanceKm, timeStr)

                            mapView.setVisibleMapRect(
                                mainRoute.polyline.boundingMapRect,
                                edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                                animated: true
                            )
                        }
                    }
                }
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}

