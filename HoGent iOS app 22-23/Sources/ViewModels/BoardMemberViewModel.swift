//
//  BoardMemberViewModel.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

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
}
