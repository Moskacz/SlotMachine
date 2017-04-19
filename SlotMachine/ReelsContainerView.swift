//
//  ReelsContainerView.swift
//  SlotMachine
//
//  Created by Michał Moskała on 17.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import UIKit

class ReelsContainerView: UIView {
    
    @IBOutlet var reels: [ReelView]!
    var randomizationAlgorithm: RandomizationAlgorithm<CGFloat>?
    
    func setupViews() {
        for reel in reels {
            reel.fillWithSlots()
        }
    }
    
    func startReelsAnimation() {
        for reel in reels {
            reel.startAnimation(withSpeed: getRandomSpeed())
        }
    }
    
    private func getRandomSpeed() -> CGFloat {
        guard let algorithm = randomizationAlgorithm else {
            return 400.0
        }
        
        return algorithm.getRandom()
    }
}
