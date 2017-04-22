//
//  ResultCounterTests.swift
//  SlotMachine
//
//  Created by Michał Moskała on 22.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import XCTest
@testable import SlotMachine

class ResultCounterTests: XCTestCase {
    
    var sut: ResultCounter!
    
    func test_whenThreeReelsSelectTheSameSlot_thenItShouldRecognizeWinSituation() {
        let sut = ResultCounter(expectedResultsCount: 3)
        sut.trackResult(withSlot: SlotType.banana)
        sut.trackResult(withSlot: SlotType.banana)
        sut.trackResult(withSlot: SlotType.banana)
        XCTAssertTrue(sut.slotsMatch())
    }
    
    func test_whenThreeReelsDonotSelectTheSameSlot_thenItShouldNotRecognizeWinSituatio() {
        let sut = ResultCounter(expectedResultsCount: 3)
        sut.trackResult(withSlot: SlotType.banana)
        sut.trackResult(withSlot: SlotType.bar)
        sut.trackResult(withSlot: SlotType.cherry)
        XCTAssertFalse(sut.slotsMatch())
    }
    
    func test_whenCounterReceivedLessResoultsThanExpected_thenItShouldNotRecognizeWinSituation() {
        let sut = ResultCounter(expectedResultsCount: 2)
        sut.trackResult(withSlot: SlotType.banana)
        XCTAssertFalse(sut.slotsMatch())
    }
    
}
