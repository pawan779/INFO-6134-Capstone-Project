//
//  LocationDetailsView.swift
//  MedWise
//
//  Created by Anup Saud on 2023-11-21.
//
import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    @Binding var getDirections: Bool

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mapSelection?.placemark.name ?? "Unknown Place")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(mapSelection?.placemark.title ?? "No additional information")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                }
                Spacer()
                Button {
                    show.toggle()
                    mapSelection = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            
            if let scene = lookAroundScene {
                
                Text("Look Around Preview Here")
                    .frame(height: 150)
                    .cornerRadius(12)
                    .padding()
            } else {
              
                Text("No preview available")
                    .foregroundColor(.gray)
            }

            HStack(spacing: 24) {
                Button {
                    if let mapSelection = mapSelection {
                        mapSelection.openInMaps()
                    }
                } label: {
                    Text("Open in Map")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(.green)
                        .cornerRadius(12)
                }
                Button {
                    getDirections = true
                    show = false
                } label: {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { _ in
            fetchLookAroundPreview()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .top)
    }

    private func fetchLookAroundPreview() {
        guard let mapSelection = mapSelection else {
            lookAroundScene = nil
            return
        }
        
        Task {
            do {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try await request.scene
            } catch {
                print("Error fetching look around preview: \(error)")
                lookAroundScene = nil
            }
        }
    }
}

struct LocationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsView(mapSelection: .constant(nil), show: .constant(true), getDirections: .constant(false))
    }
}
