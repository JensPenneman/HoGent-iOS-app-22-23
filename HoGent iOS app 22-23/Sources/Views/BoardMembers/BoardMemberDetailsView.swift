//
//  BoardMemberDetailsView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardMemberDetailsView: View {
    let boardMember: BoardMember
    
    var body: some View {
        VStack {
            
        }
        .navigationTitle("\(boardMember.firstname) \(boardMember.lastname)")
    }
}

struct BoardMemberDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BoardMemberDetailsView(boardMember:
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
    }
}
