//
//  RandomSlotsProviderTests.swift
//  SlotMachine
//
//  Created by Michał Moskała on 23.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import XCTest
@testable import SlotMachine

class RandomSlotsProviderTests: XCTestCase {
    
    func test_generatedArray_shouldHave9Slots() {
        let sut = RandomSlotsProvider()
        let slots = sut.getSlots()
        XCTAssert(slots.count == 9)
    }
    
    func test_twoGeneratedArrays_shouldNotBeTheSame() {
        let sut = RandomSlotsProvider()
        let slots1 = sut.getSlots()
        let slots2 = sut.getSlots()
        XCTAssert(slots1 != slots2)
    }
    
}
