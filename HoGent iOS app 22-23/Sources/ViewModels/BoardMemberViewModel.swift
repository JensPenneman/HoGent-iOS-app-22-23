//
//  BoardMemberViewModel.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI
import PostgREST

class BoardMemberViewModel: ObservableObject {
    @Published var boardMembers: [BoardMember] = []
    private lazy var client = RESTClient.shared
    
    static let shared = BoardMemberViewModel()
    private init() {
        Task {
            try? await refreshBoardMembers()
        }
    }
    
    
    //MARK: - Intents
    func refreshBoardMembers() async throws {
        let query = client
            .database
            .from("boardmembers")
            .select(columns: "*, boardtasks (*)")
        
        guard
            let response = try? await query.execute(),
            let boardMembers = try? response.decoded(to: [BoardMember].self)
        else {
            print("Error while decoding board members")
            return
        }
        
        DispatchQueue.main.async {
            self.boardMembers.removeAll { boardMember in !boardMembers.contains(boardMember) }
            self.boardMembers.append(contentsOf: boardMembers.filter({ boardMember in !self.boardMembers.contains(boardMember)}))
        }
    }
    
    func addBoardMember(_ boardmember: BoardMember) async {
        await addBoardMember(firstname: boardmember.firstname, lastname: boardmember.lastname, mail: boardmember.mail)
    }
    
    func addBoardMember(firstname: String, lastname: String, mail: String) async {
        let query = client
            .database
            .from("boardmembers")
            .insert(values: [
                "firstname": firstname,
                "lastname": lastname,
                "mail": mail
            ])
        
        await execute(query)
        try? await refreshBoardMembers()
    }
    
    func relate(task boardTask: BoardTask, to boardMember: BoardMember) async {
        await relate(task: boardTask.id, to: boardMember.id)
    }
    
    func relate(task boardTaskId: UUID, to boardMemberId: UUID) async {
        let query = client
            .database
            .from("boardmembershaveboardtasks")
            .insert(values: [
                "board_member_id": boardMemberId.uuidString,
                "board_task_id": boardTaskId.uuidString
            ])
        
        await execute(query)
        try? await refreshBoardMembers()
    }
    
    func unrelate(task boardTask: BoardTask, from boardMember: BoardMember) async {
        await unrelate(task: boardTask.id, from: boardMember.id)
    }
    
    func unrelate(task taskId: UUID, from memberId: UUID) async {
        let query = client
            .database
            .from("boardmembershaveboardtasks")
            .delete()
            .equals(column: "board_member_id", value: memberId.uuidString)
            .equals(column: "board_task_id", value: taskId.uuidString)
        
        await execute(query)
        try? await refreshBoardMembers()
    }
    
    private func unrelateAll(from boardMember: BoardMember) async {
        for boardTask in boardMember.boardtasks { await unrelate(task: boardTask, from: boardMember) }
    }
    
    private func unrelateAll(from boardMemberId: UUID) async {
        await unrelateAll(from: boardMembers.first(where: { boardMember in boardMember.id == boardMemberId })!)
    }
    
    func deleteBoardMember(_ boardMember: BoardMember) async {
        await deleteBoardMember(by: boardMember.id)
    }
    
    func deleteBoardMember(by id: UUID) async {
        let query = client
            .database
            .from("boardmembers")
            .delete()
            .equals(column: "id", value: id.uuidString)
        
        await unrelateAll(from: id)
        await execute(query)
        try? await refreshBoardMembers()
    }
    
    
    private func execute(_ query: PostgrestFilterBuilder) async {
        do{
            _ = try await query.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
}
