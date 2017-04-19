//
//  RandomizationAlgorithm.swift
//  SlotMachine
//
//  Created by Michał Moskała on 19.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import UIKit

class RandomizationAlgorithm<T> {
    func getRandom() -> T {
        fatalError("abstract method called")
    }
}

class SpeedRandomizationAlgorithm: RandomizationAlgorithm<CGFloat> {
    
    private let minValue: CGFloat
    private let maxValue: CGFloat
    
    init(minValue: CGFloat, maxValue: CGFloat) {
        assert(maxValue > minValue)
        self.minValue = minValue
        self.maxValue = maxValue
    }
    
    override func getRandom() -> CGFloat {
        let randomRange = maxValue - minValue
        let randomValue = CGFloat(Float(arc4random()) / Float(UInt32.max)) * randomRange
        return minValue + randomValue
    }
}
