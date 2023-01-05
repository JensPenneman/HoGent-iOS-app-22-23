//
//  BoardListView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardListView: View {
    @StateObject private var boardMemberViewModel = BoardMemberViewModel()
    
    var body: some View {
        List {
            Section {
                ForEach(boardMemberViewModel.boardMembers, id: \.self.id) { boardMember in
                    NavigationLink("\(boardMember.firstname) \(boardMember.lastname)", value: NavigationState.boardMember(boardMember))
                }
                .onDelete(perform: deleteMember)
            } header: { Label("Board members", systemImage: "person.3") }
            Section {  } header: { Label("Board tasks", systemImage: "list.bullet") }
        }
        .refreshable { await refresh() }
    }
    
    private func refresh() async {
        try? await boardMemberViewModel.refreshBoardMembers()
    }
    
    private func deleteMember(at indexSet: IndexSet) {
        for index in indexSet { delete(boardMemberViewModel.boardMembers[index]) }
    }
    
    private func delete(_ boardMember: BoardMember) {
        Task { await boardMemberViewModel.deleteBoardMember(boardMember) }
    }
}

struct BoardListView_Previews: PreviewProvider {
    static var previews: some View {
        BoardListView()
    }
}
