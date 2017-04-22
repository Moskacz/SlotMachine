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
    
    var resultCounter: ResultCounter?
    var randomizationAlgorithm: RandomizationAlgorithm<CGFloat>?
    private let elements: [SlotElement] = [SlotElement(image: #imageLiteral(resourceName: "slot1"), type: .seven),
                                           SlotElement(image: #imageLiteral(resourceName: "slot2"), type: .watermelon),
                                           SlotElement(image: #imageLiteral(resourceName: "slot3"), type: .plum),
                                           SlotElement(image: #imageLiteral(resourceName: "slot4"), type: .lemon),
                                           SlotElement(image: #imageLiteral(resourceName: "slot5"), type: .banana),
                                           SlotElement(image: #imageLiteral(resourceName: "slot6"), type: .bigWin),
                                           SlotElement(image: #imageLiteral(resourceName: "slot7"), type: .cherry),
                                           SlotElement(image: #imageLiteral(resourceName: "slot8"), type: .bar),
                                           SlotElement(image: #imageLiteral(resourceName: "slot9"), type: .orange)]

    
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
            return 400.0
        }
        
        return algorithm.getRandom()
    }
    
    // MARK: ReelViewDataSource
    
    func getElement(forIndex index: Int) -> SlotElement {
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
