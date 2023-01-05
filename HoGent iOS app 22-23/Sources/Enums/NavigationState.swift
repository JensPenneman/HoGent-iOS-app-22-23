//
//  NavigationState.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import Foundation

enum NavigationState: Hashable {
    case boardMember(BoardMember)
    case boardTask(BoardTask)
}
