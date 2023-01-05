//
//  BoardMemberModel.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import Foundation

struct BoardMember: Identifiable, Codable, Hashable {
    var id: UUID
    var firstname: String
    var lastname: String
    var mail: String
    var boardtasks: [BoardTask]
}
