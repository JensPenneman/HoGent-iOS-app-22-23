//
//  BoardMemberCreateView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardMemberCreateView: View {
    @StateObject private var boardMemberViewModel = BoardMemberViewModel.shared
    
    @Binding var isPresenting: Bool
    
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var mail: String = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Firstname", text: $firstname)
                TextField("Lastname", text: $lastname)
                TextField("Mailadres", text: $mail)
            } header: {
                Text("Add a new board member")
                    .font(.headline)
            }
            Section {
                Button ("Add") { addMember() }
                Button ("Cancel", role: .cancel) { isPresenting = false }
            }
        }
    }
    
    private func addMember() {
        guard
            self.firstname != "",
            self.lastname != "",
            self.mail != ""
        else {return}
        
        Task { await boardMemberViewModel.addBoardMember(firstname: firstname, lastname: lastname, mail: mail) }
        isPresenting = false
    }
}

struct BoardMemberCreateButtonView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            Label("Add new member", systemImage: "plus")
        }
    }
}

struct BoardMemberCreateView_Previews: PreviewProvider {
    static var previews: some View {
        BoardMemberCreateView(isPresenting: .constant(true))
    }
}
