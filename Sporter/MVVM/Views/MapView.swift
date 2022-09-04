//
//  MapView.swift
//  Sporter
//
//  Created by Minh Pham on 31/08/2022.
//

import SwiftUI

struct MapView: View {
    @ObservedObject var mapViewModel = MapViewModel()
    
    var body: some View {
        VStack {
            List(mapViewModel.venues) { venue in
                Text(venue.name)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
