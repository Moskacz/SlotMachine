//
//  SlotsProvider.swift
//  SlotMachine
//
//  Created by Michał Moskała on 23.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import Foundation

protocol SlotsProvider {
    func getSlots() -> [SlotElement]
}

class RandomSlotsProvider: SlotsProvider {
    
    private let elements: [SlotElement] = [SlotElement(image: #imageLiteral(resourceName: "slot1"), type: .seven),
                                           SlotElement(image: #imageLiteral(resourceName: "slot2"), type: .watermelon),
                                           SlotElement(image: #imageLiteral(resourceName: "slot3"), type: .plum),
                                           SlotElement(image: #imageLiteral(resourceName: "slot4"), type: .lemon),
                                           SlotElement(image: #imageLiteral(resourceName: "slot5"), type: .banana),
                                           SlotElement(image: #imageLiteral(resourceName: "slot6"), type: .bigWin),
                                           SlotElement(image: #imageLiteral(resourceName: "slot7"), type: .cherry),
                                           SlotElement(image: #imageLiteral(resourceName: "slot8"), type: .bar),
                                           SlotElement(image: #imageLiteral(resourceName: "slot9"), type: .orange)]
 
    func getSlots() -> [SlotElement] {
        var slots = [SlotElement]()
        for _ in 0..<elements.count {
            let element = elements[getRandomIndex()]
            slots.append(element)
        }
        return slots
    }
    
    private func getRandomIndex() -> Int {
        return Int(arc4random()) % elements.count
    }
    
}
