//
//  BoardTaskDetailsView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardTaskDetailsView: View {
    let boardTask: BoardTask
    
    var body: some View {
        Text("Board tasks have nothing more than a name!")
        .navigationTitle(boardTask.name)
    }
}

struct BoardTaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BoardTaskDetailsView(boardTask: BoardTask(id: UUID(), name: "Example task"))
    }
}
