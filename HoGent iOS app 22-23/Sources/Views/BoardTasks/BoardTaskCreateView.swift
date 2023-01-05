//
//  BoardTaskCreateView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardTaskCreateView: View {
    @StateObject private var boardTaskViewModel = BoardTaskViewModel.shared
    
    @Binding var isPresenting: Bool
    
    @State var name: String = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
            } header: {
                Text("Add a new board task")
                    .font(.headline)
            }
            Section {
                Button ("Add") { addTask() }
                Button ("Cancel", role: .cancel) { isPresenting = false }
            }
        }
    }
    
    private func addTask() {
        guard self.name != ""
        else {return}
        
        Task { await boardTaskViewModel.addBoardTask(name: name) }
        isPresenting = false
    }
}

struct BoardTaskCreateButtonView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            Label("Add new task", systemImage: "plus")
        }
    }
}

struct BoardTaskCreateView_Previews: PreviewProvider {
    static var previews: some View {
        BoardTaskCreateView(isPresenting: .constant(true))
    }
}
