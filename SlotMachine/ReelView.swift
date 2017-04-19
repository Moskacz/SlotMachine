//
//  ReelView.swift
//  SlotMachine
//
//  Created by Michał Moskała on 17.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import UIKit

class ReelView: UIView {
    
    private let slotHorizontalMargin: CGFloat = 8.0
    private let spaceBetweenSlots: CGFloat = 8.0
    private var slotViews = [UIView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 2.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        clipsToBounds = true
    }
    
    func fillWithSlots() {
        let centerSlot = createCenterSlot()
        createSlotAbove(slot: centerSlot)
        createSlotsBelow(slot: centerSlot)
    }
    
    func startAnimation(withOnePassDuration duration: CGFloat) {
        
    }
    
    // MARK: slots creation
    
    private func createCenterSlot() -> SlotView {
        let size = slotSize()
        let slotFrame = CGRect(x: slotHorizontalMargin, y: bounds.midY - size.height / 2.0, width: size.width, height: size.height)
        let slot = SlotView(frame: slotFrame)
        addSubview(slot)
        slotViews.append(slot)
        return slot
    }
    
    private func createSlotsBelow(slot: UIView) {
        var nextSlotFrame = slot.frame
        nextSlotFrame.origin.y += (spaceBetweenSlots + slot.bounds.height)
        
        while nextSlotFrame.origin.y < bounds.maxY {
            let slot = SlotView(frame: nextSlotFrame)
            addSubview(slot)
            slotViews.append(slot)
            nextSlotFrame.origin.y += (spaceBetweenSlots + slot.bounds.height)
        }
    }
    
    private func createSlotAbove(slot: UIView) {
        var nextSlotFrame = slot.frame
        nextSlotFrame.origin.y -= (spaceBetweenSlots + slot.bounds.height)
        
        while nextSlotFrame.maxY > 0 {
            let slot = SlotView(frame: nextSlotFrame)
            addSubview(slot)
            slotViews.append(slot)
            nextSlotFrame.origin.y -= (spaceBetweenSlots + slot.bounds.height)
        }
    }
    
    private func slotSize() -> CGSize {
        let reelWidth = bounds.width
        let slotWidth = reelWidth - 2.0 * slotHorizontalMargin
        return CGSize(width: slotWidth, height: slotWidth)
    }
}
