//
//  SlotType.swift
//  SlotMachine
//
//  Created by Michał Moskała on 22.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import UIKit

enum SlotType {
    case seven
    case watermelon
    case plum
    case lemon
    case banana
    case bigWin
    case cherry
    case bar
    case orange
}

struct SlotElement: Equatable {
    let image: UIImage
    let type: SlotType
}

func ==(lhs:SlotElement, rhs:SlotElement) -> Bool {
    return lhs.type == rhs.type
}
