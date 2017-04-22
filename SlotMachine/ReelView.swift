//
//  ReelView.swift
//  SlotMachine
//
//  Created by Michał Moskała on 17.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import UIKit

enum ReelViewError: Error {
    case zeroSpeedGiven
}

class ReelView: UIView {
    
    private let slotHorizontalMargin: CGFloat = 8.0
    private let spaceBetweenSlots: CGFloat = 8.0
    private var visibleSlots = [UIView]()
    private var animationSpeed: CGFloat = 0.0
    private var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 2.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        clipsToBounds = true
    }
    
    // MARK: slots creation
    
    func fillWithSlots() {
        createSlots()
        centerSlots()
    }
    
    private func createSlots() {
        let size = slotSize()
        var origin = CGPoint(x: slotHorizontalMargin, y: -size.height)
        
        while origin.y < bounds.maxY {
            let frame = CGRect(origin: origin, size: size)
            let slotView = SlotView(frame: frame)
            addSubview(slotView)
            visibleSlots.append(slotView)
            origin.y += (size.height + spaceBetweenSlots)
        }
    }
    
    private func centerSlots() {
        let centerSlot = middleSlot()
        let verticalOffset = bounds.midY - centerSlot.frame.midY
        
        for slot in visibleSlots {
            slot.frame.origin.y += verticalOffset
        }
    }
    
    private func middleSlot() -> UIView {
        let reelVerticalCenter = bounds.midY
        
        let sortedByDistance = visibleSlots.sorted { (left: UIView, right: UIView) -> Bool in
            let leftDistance = fabs(reelVerticalCenter - left.frame.midY)
            let rightDistance = fabs(reelVerticalCenter - right.frame.midY)
            return leftDistance < rightDistance
        }
        
        return sortedByDistance[0]
    }
    
    private func slotSize() -> CGSize {
        let reelWidth = bounds.width
        let slotWidth = reelWidth - 2.0 * slotHorizontalMargin
        return CGSize(width: slotWidth, height: slotWidth)
    }
    
    // MARK: Animation
    
    func startAnimation(withSpeed speed: CGFloat) throws {
        guard speed != 0.0 else {
            throw ReelViewError.zeroSpeedGiven
        }
        
        animationSpeed = speed
        for slot in visibleSlots {
            startAnimation(forSlot: slot)
        }
    }
    
    private func startAnimation(forSlot slot: UIView) {
        let distance = bounds.maxY - slot.frame.minY
        let duration = getAnimationDuration(forDistance: distance)
        animate(slot: slot, withDuration: duration)
    }
    
    private func getAnimationDuration(forDistance distance: CGFloat) -> TimeInterval {
        return TimeInterval(distance / animationSpeed)
    }
    
    private func animate(slot: UIView, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            slot.frame.origin.y = self.bounds.maxY
        }, completion: { (completed: Bool) in
            self.startRepeatAnimation(forSlot: slot)
        })
    }
    
    private func startRepeatAnimation(forSlot slot: UIView) {
        let delay = delayDuration(forSlot: slot)
        setSlotAboveReel(slot: slot)
        let distance = bounds.maxY - slot.frame.minY
        let duration = getAnimationDuration(forDistance: distance)
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveLinear,
                       animations: {
                        
            slot.frame.origin.y = self.bounds.maxY
        }, completion: { (completed: Bool) in
            self.startRepeatAnimation(forSlot: slot)
        })
    }
    
    private func delayDuration(forSlot slot: UIView) -> TimeInterval {
        let presentationLayers = visibleSlots.flatMap { $0.layer.presentation() }
        let sortedLayers = presentationLayers.sorted { (left:CALayer, right: CALayer) -> Bool in
            return left.frame.minY < right.frame.minY
        }
        
        let topLayer = sortedLayers[0]
        let distance = -topLayer.frame.minY + spaceBetweenSlots
        return getAnimationDuration(forDistance: distance)
    }
    
    private func setSlotAboveReel(slot: UIView) {
        let size = slotSize()
        slot.frame = CGRect(x: slotHorizontalMargin, y: -size.height, width: size.width, height: size.height)
    }
}
