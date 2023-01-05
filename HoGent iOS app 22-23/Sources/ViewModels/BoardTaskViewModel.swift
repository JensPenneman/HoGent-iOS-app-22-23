//
//  BoardTaskViewModel.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI
import PostgREST

class BoardTaskViewModel: ObservableObject {
    @Published var boardTasks: [BoardTask] = []
    private lazy var client = RESTClient.shared
    
    init() {
        Task {
            try? await refreshBoardTasks()
        }
    }
    
    
    //MARK: - Intents
    func refreshBoardTasks() async throws {
        let query = client
            .database
            .from("boardtasks")
            .select(columns: "*")
        
        guard
            let response = try? await query.execute(),
            let boardTasks = try? response.decoded(to: [BoardTask].self)
        else {
            print("Error while decoding board tasks")
            return
        }
        
        DispatchQueue.main.async {
            self.boardTasks.removeAll { boardTask in !boardTasks.contains(boardTask) }
            self.boardTasks.append(contentsOf: boardTasks.filter({ boardTask in !self.boardTasks.contains(boardTask) }))
        }
    }
    
    func deleteBoardTask(_ boardTask: BoardTask) async {
        await deleteBoardTask(by: boardTask.id)
    }
    
    private func deleteBoardTask(by id: UUID) async {
        let query = client
            .database
            .from("boardtasks")
            .delete()
            .equals(column: "id", value: id.uuidString)
        
        //FIXME: Unrelate task from all members before deleting, otherwise delete won't work
        await execute(query)
        try? await refreshBoardTasks()
    }
    
    
    private func execute(_ query: PostgrestFilterBuilder) async {
        do{
            _ = try await query.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
}
