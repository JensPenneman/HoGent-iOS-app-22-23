//
//  BoardDetailsView.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import SwiftUI

struct BoardDetailsView: View {
    let navigationState: NavigationState
    
    var body: some View {
        switch navigationState {
        case .boardMember(let boardMember): BoardMemberDetailsView()
        case .boardTask(let boardTask): BoardTaskDetailsView()
        }
    }
}

//struct BoardDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardDetailsView()
//    }
//}
