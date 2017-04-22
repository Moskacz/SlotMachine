//
//  ResultCounter.swift
//  SlotMachine
//
//  Created by Michał Moskała on 22.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import Foundation

class ResultCounter {
    
    private var expectedResultsCount: Int
    private var resultSlots = [SlotType]()
    
    init(expectedResultsCount: Int) {
        self.expectedResultsCount = expectedResultsCount
    }
    
    func startTracking() {
        resultSlots.removeAll()
    }
    
    func trackResult(withSlot slot: SlotType) {
        resultSlots.append(slot)
    }
    
    func slotsMatch() -> Bool {
        guard resultSlots.count == expectedResultsCount else {
            return false
        }
        
        let resultsSet = Set(resultSlots)
        return resultsSet.count == 1
    }
}
