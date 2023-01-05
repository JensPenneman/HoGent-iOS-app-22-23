//
//  NavigationViewModel.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

final class NavigationManager: ObservableObject {
    @Published var navigationPath: [NavigationState]
    
    init(_ navigationPath: [NavigationState] = []) {
        self.navigationPath = navigationPath
    }
}
