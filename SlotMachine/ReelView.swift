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
    private var visibleSlots = [UIView]()
    private var animationSpeed: CGFloat = 1.0
    
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
    
    func startAnimation(withSpeed speed: CGFloat) {
        for slot in visibleSlots {
            startAnimation(forSlot: slot, withSpeed: speed)
        }
    }
    
    private func startAnimation(forSlot slot: UIView, withSpeed speed: CGFloat) {
        let distance = bounds.maxY - slot.frame.minY
        animationSpeed = speed
        if animationSpeed != 0.0 {
            let animationDuration = TimeInterval(distance / speed)
            animate(slot: slot, withDuration: animationDuration)
        }
    }
    
    private func animate(slot: UIView, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            slot.frame.origin.y = self.bounds.maxY
        }, completion: { (completed: Bool) in
            slot.frame.origin.y = -slot.bounds.height
            self.startAnimation(forSlot: slot, withSpeed: self.animationSpeed)
        })
    }
    
    // MARK: slots creation
    
    private func createCenterSlot() -> SlotView {
        let size = slotSize()
        let slotFrame = CGRect(x: slotHorizontalMargin, y: bounds.midY - size.height / 2.0, width: size.width, height: size.height)
        let slot = SlotView(frame: slotFrame)
        addSubview(slot)
        visibleSlots.append(slot)
        return slot
    }
    
    private func createSlotsBelow(slot: UIView) {
        var nextSlotFrame = slot.frame
        nextSlotFrame.origin.y += (spaceBetweenSlots + slot.bounds.height)
        
        while nextSlotFrame.origin.y < bounds.maxY {
            let slot = SlotView(frame: nextSlotFrame)
            addSubview(slot)
            visibleSlots.append(slot)
            nextSlotFrame.origin.y += (spaceBetweenSlots + slot.bounds.height)
        }
    }
    
    private func createSlotAbove(slot: UIView) {
        var nextSlotFrame = slot.frame
        nextSlotFrame.origin.y -= (spaceBetweenSlots + slot.bounds.height)
        
        while nextSlotFrame.maxY > 0 {
            let slot = SlotView(frame: nextSlotFrame)
            addSubview(slot)
            visibleSlots.append(slot)
            nextSlotFrame.origin.y -= (spaceBetweenSlots + slot.bounds.height)
        }
    }
    
    private func slotSize() -> CGSize {
        let reelWidth = bounds.width
        let slotWidth = reelWidth - 2.0 * slotHorizontalMargin
        return CGSize(width: slotWidth, height: slotWidth)
    }
}
