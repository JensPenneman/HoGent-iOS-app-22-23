//
//  ContentView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager()
    
    var body: some View {
        NavigationStack (path: $navigationManager.navigationPath) {
            BoardListView()
                .navigationTitle("Board")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: NavigationState.self) { navigationState in BoardDetailsView(navigationState: navigationState) }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
