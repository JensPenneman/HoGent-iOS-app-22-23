//
//  BoardDetailsView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardDetailsView: View {
    let navigationState: NavigationState
    
    var body: some View {
        switch navigationState {
        case .boardMember(let boardMember): BoardMemberDetailsView()
        case .boardTask(let boardTask): BoardTaskDetailsView(boardTask: boardTask)
        }
    }
}

struct BoardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetailsView(navigationState: NavigationState
            .boardMember(
                BoardMember(
                    id: UUID(),
                    firstname: "Jens",
                    lastname: "Penneman",
                    mail: "jenspenneman@gmail.com",
                    boardtasks: [
                        BoardTask(
                            id: UUID(),
                            name: "Example task")
                    ]
                )
            )
        )
        .previewDisplayName("With example member")
        
        BoardDetailsView(navigationState: NavigationState
            .boardTask(
                BoardTask(
                    id: UUID(),
                    name: "Example task"
                )
            )
        )
        .previewDisplayName("With example task")
    }
}
