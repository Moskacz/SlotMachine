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
    
    private let defaultReelSpeed: CGFloat = 400.0
    
    func setupViews() {
        for reel in reels {
            reel.fillWithSlots()
        }
    }
    
    func startReelsAnimation() {
        for reel in reels {
            reel.startAnimation(withSpeed: defaultReelSpeed)
        }
    }
}
