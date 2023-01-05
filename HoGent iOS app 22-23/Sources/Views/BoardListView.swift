//
//  BoardListView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardListView: View {
    @StateObject private var boardMemberViewModel = BoardMemberViewModel.shared
    @StateObject private var boardTaskViewModel = BoardTaskViewModel.shared
    
    @State private var showMemberCreateSheet = false
    @State private var showTaskCreateSheet = false
    
    var body: some View {
        List {
            Section {
                ForEach(boardMemberViewModel.boardMembers, id: \.self.id) { boardMember in
                    NavigationLink("\(boardMember.firstname) \(boardMember.lastname)", value: NavigationState.boardMember(boardMember))
                }
                .onDelete(perform: deleteMember)
                BoardMemberCreateButtonView(isActive: $showMemberCreateSheet)
            } header: { Label("Board members", systemImage: "person.3") }
            Section {
                ForEach(boardTaskViewModel.boardTasks, id: \.self.id) { boardTask in
                    NavigationLink(boardTask.name, value: NavigationState.boardTask(boardTask))
                }
                .onDelete(perform: deleteTask)
                BoardTaskCreateButtonView(isActive: $showTaskCreateSheet)
            } header: { Label("Board tasks", systemImage: "list.bullet") }
        }
        .refreshable { await refresh() }
        .sheet(isPresented: $showMemberCreateSheet) { BoardMemberCreateView(isPresenting: $showMemberCreateSheet) }
        .sheet(isPresented: $showTaskCreateSheet) { BoardTaskCreateView(isPresenting: $showTaskCreateSheet) }
    }
    
    private func refresh() async {
        try? await boardMemberViewModel.refreshBoardMembers()
        try? await boardTaskViewModel.refreshBoardTasks()
    }
    
    private func deleteMember(at indexSet: IndexSet) {
        for index in indexSet { delete(boardMemberViewModel.boardMembers[index]) }
    }
    
    private func delete(_ boardMember: BoardMember) {
        Task { await boardMemberViewModel.deleteBoardMember(boardMember) }
    }
    
    private func deleteTask(at indexSet: IndexSet) {
        for index in indexSet { delete(boardTaskViewModel.boardTasks[index]) }
    }
    
    private func delete(_ boardTask: BoardTask) {
        Task { await boardTaskViewModel.deleteBoardTask(boardTask) }
    }
}

struct BoardListView_Previews: PreviewProvider {
    static var previews: some View {
        BoardListView()
    }
}
