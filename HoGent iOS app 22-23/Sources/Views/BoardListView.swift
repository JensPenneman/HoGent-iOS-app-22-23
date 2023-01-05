//
//  BoardListView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardListView: View {
    var body: some View {
        List {
            Section {  } header: { Label("Board members", systemImage: "person.3") }
            Section {  } header: { Label("Board tasks", systemImage: "list.bullet") }
        }
//        .refreshable {  } TODO: Add refreshable function
    }
}

struct BoardListView_Previews: PreviewProvider {
    static var previews: some View {
        BoardListView()
    }
}
