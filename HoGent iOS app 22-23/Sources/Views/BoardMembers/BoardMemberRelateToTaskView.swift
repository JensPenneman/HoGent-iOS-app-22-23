//
//  BoardMemberRelateToTaskView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardMemberRelateToTaskView: View {
    let boardMember: BoardMember
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var boardMemberViewModel = BoardMemberViewModel.shared
    @StateObject private var boardTaskViewModel = BoardTaskViewModel.shared
    
    @Binding var isPresenting: Bool
    
    @State var selectedTask: BoardTask?
    
    var body: some View {
        Form {
            Section {
                Picker("Task", selection: $selectedTask) {
                    Text("").tag(Optional<BoardTask>(nil))
                    ForEach (boardTaskViewModel.boardTasks.filter({ boardTask in !boardMember.boardtasks.contains(boardTask)}), id: \.self) { boardTask in
                        Text(boardTask.name).tag(Optional<BoardTask>(boardTask))
                    }
                }
            } header: {
                Text("Relate task to \(boardMember.firstname)")
                    .font(.headline)
            }
            Section {
                Button ("Relate") { relateTask() }
                Button ("Cancel", role: .cancel) { isPresenting = false }
            }
        }
    }
    
    private func relateTask() {
        guard self.selectedTask != nil else { return }
        
        Task {
            await boardMemberViewModel.relate(task: selectedTask!, to: boardMember)
            await refresh()
        }
        
        isPresenting = false
    }
    
    private func refresh() async {
        let _ = try? await boardMemberViewModel.refreshBoardMembers()
        navigationManager.navigationPath.removeLast()
        navigationManager.navigationPath.append(
            NavigationState.boardMember(
                boardMemberViewModel.boardMembers.first(where: { boardMember in boardMember.id == self.boardMember.id })!
            )
        )
    }
}

struct BoardMemberRelateToTaskButtonView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            Label("Relate task", systemImage: "link")
        }
    }
}


struct BoardMemberRelateToTaskView_Previews: PreviewProvider {
    static var previews: some View {
        BoardMemberRelateToTaskView(
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
                ),
            isPresenting: .constant(true)
        )
    }
}
