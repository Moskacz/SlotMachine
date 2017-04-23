//
//  ReelsContainerView.swift
//  SlotMachine
//
//  Created by Michał Moskała on 17.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import UIKit

class ReelsContainerView: UIView, ReelViewDataSource, ReelViewDelegate {
    
    @IBOutlet var reels: [ReelView]!
    @IBOutlet var selectionView: UIView!
    private let defaultAnimationSpeed: CGFloat = 400.0
    
    var resultCounter: ResultCounter?
    var randomizationAlgorithm: RandomizationAlgorithm<CGFloat>?
    var reelsElements = [[SlotElement]]()
    
    func setupViews() {
        for reel in reels {
            reel.dataSource = self
            reel.delegate = self
            reel.fillWithSlots()
        }
    }
    
    func startReelsAnimation() {
        resultCounter?.startTracking()
        for reel in reels {
            do {
                try reel.startAnimation(withSpeed: getRandomSpeed())
            } catch {
                print(error)
            }
        }
    }
    
    func stopReels() {
        for reel in reels {
            reel.stopAnimation()
        }
    }
    
    // MARK: generating speed
    
    private func getRandomSpeed() -> CGFloat {
        guard let algorithm = randomizationAlgorithm else {
            return defaultAnimationSpeed
        }
        
        return algorithm.getRandom()
    }
    
    // MARK: ReelViewDataSource
    
    func getElement(forReel reel: ReelView, atIndex index: Int) -> SlotElement {
        let reelIndex: Int = reels.index(of: reel)!
        let elements = reelsElements[reelIndex]
        let slotIndex = index % elements.count
        return elements[slotIndex]
    }
    
    // MARK: ReelViewDelegate
    
    func reelView(_ reelView: ReelView, didSelectElement element: SlotElement) {
        resultCounter?.trackResult(withSlot: element.type)
        let slotMatches = resultCounter?.slotsMatch() ?? false
        if slotMatches {
            print("YOU WON!")
        }
    }
}
