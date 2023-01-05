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
    
    init() {
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
            self.boardMembers.removeAll { boardMember in true }
            self.boardMembers.append(contentsOf: boardMembers)
        }
    }
    
    func deleteBoardMember(_ boardMember: BoardMember) async {
        await deleteBoardMember(by: boardMember.id)
    }
    
    private func deleteBoardMember(by id: UUID) async {
        let query = client
            .database
            .from("boardmembers")
            .delete()
            .equals(column: "id", value: id.uuidString)
        
        //FIXME: Unrelate all tasks before deleting, otherwise delete won't work
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
