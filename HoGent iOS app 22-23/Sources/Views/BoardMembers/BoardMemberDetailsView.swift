//
//  BoardMemberDetailsView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardMemberDetailsView: View {
    let boardMember: BoardMember
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var boardMemberViewModel = BoardMemberViewModel.shared
    
    @State private var isRelatingTask = false
    
    var body: some View {
        VStack {
            Text(boardMember.mail)
            List {
                Section {
                    ForEach(boardMember.boardtasks, id: \.self.id) { boardTask in
                        NavigationLink(boardTask.name, value: NavigationState.boardTask(boardTask))
                    }
                    .onDelete(perform: unrelateTask)
                    BoardMemberRelateToTaskButtonView(isActive: $isRelatingTask)
                }
            }
        }
        .navigationTitle("\(boardMember.firstname) \(boardMember.lastname)")
        .refreshable { await refresh() }
        .sheet(isPresented: $isRelatingTask) { BoardMemberRelateToTaskView(boardMember: boardMember, isPresenting: $isRelatingTask) }
    }
    
    private func refresh() async {
        try? await boardMemberViewModel.refreshBoardMembers()
        navigationManager.navigationPath.removeLast()
        navigationManager.navigationPath.append(
            NavigationState.boardMember(
                boardMemberViewModel.boardMembers.first(where: { boardMember in boardMember.id == self.boardMember.id })!
            )
        )
    }
    
    private func unrelateTask(at indexSet: IndexSet) {
        for index in indexSet { unrelateTask(boardMember.boardtasks[index]) }
    }
    
    private func unrelateTask(_ boardTask: BoardTask) {
        Task {
            await boardMemberViewModel.unrelate(task: boardTask, from: boardMember)
            await refresh()
        }
    }
}

struct BoardMemberDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BoardMemberDetailsView(
            boardMember:
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
        .environmentObject(NavigationManager())
    }
}
