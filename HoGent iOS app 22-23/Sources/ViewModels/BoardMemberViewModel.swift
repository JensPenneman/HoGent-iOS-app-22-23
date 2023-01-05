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
