//
//  BoardTaskModel.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import Foundation

struct BoardTask: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
}
