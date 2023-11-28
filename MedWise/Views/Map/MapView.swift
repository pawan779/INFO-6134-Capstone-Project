//
//  MapView.swift
//  MedWise
//
//  Created by Anup Saud on 2023-11-21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var searchText = "DrugStore"
    @State private var results = [MKMapItem]()
    @State private var mapSelection: MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?

    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection) {
            Annotation("My location", coordinate: locationManager.currentLocation ?? CLLocationCoordinate2D()) {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.blue.opacity(0.25))
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.blue)
                }
            }
            ForEach(results, id: \.self) { item in
                let placeMark = item.placemark
                Marker(placeMark.name ?? "", coordinate: placeMark.coordinate)
            }
            if let route = route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
            }
        }
        .overlay(alignment: .top) {
            TextField("Search for a location...", text: $searchText)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .padding()
                .shadow(radius: 10)
        }
        .onAppear {
            Task {
                await searchPlaces()
            }
        }
        .onChange(of: getDirections) { newValue in
            if newValue {
                fetchRoute()
            }
        }
        .onChange(of: mapSelection) { newValue in
            showDetails = newValue != nil
            if newValue != nil {
                getDirections = false
            }
        }
        .sheet(isPresented: $showDetails) {
            if let mapSelection = mapSelection {
                LocationDetailsView(mapSelection: $mapSelection, show: $showDetails, getDirections: $getDirections)
                    .presentationDetents([.height(340)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
            }
        }
        .mapControls {
            MapCompass()
            MapUserLocationButton()
        }
        .onReceive(locationManager.$currentLocation) { newLocation in
            updateCameraPosition(newLocation)
        }
    }

    private func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: locationManager.currentLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

        self.route = nil
        self.routeDisplaying = false
        self.routeDestination = nil
        self.mapSelection = nil

        do {
            let response = try await MKLocalSearch(request: request).start()
            self.results = response.mapItems
            if let firstItemLocation = response.mapItems.first?.placemark.coordinate {
                let region = MKCoordinateRegion(center: firstItemLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
                cameraPosition = .region(region)
            }
        } catch {
            print("Error occurred during search: \(error)")
        }
    }

    private func fetchRoute() {
        guard let mapSelection = mapSelection, let userLocation = locationManager.currentLocation else {
            route = nil
            return
        }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = mapSelection

        Task {
            do {
                let result = try await MKDirections(request: request).calculate()
                route = result.routes.first
                routeDestination = mapSelection

                if let rect = route?.polyline.boundingMapRect {
                    withAnimation {
                        routeDisplaying = true
                        showDetails = false
                        cameraPosition = .rect(rect)
                    }
                }
            } catch {
                print("Error calculating route: \(error)")
                route = nil
            }
        }
    }

    private func updateCameraPosition(_ newLocation: CLLocationCoordinate2D?) {
        if let location = newLocation {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
            cameraPosition = .region(region)
        }
    }
}
