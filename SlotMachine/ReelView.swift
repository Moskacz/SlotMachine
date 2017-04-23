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

protocol ReelViewDataSource: class {
    func getElement(forReel reel: ReelView, atIndex index: Int) -> SlotElement
}

protocol ReelViewDelegate: class {
    func reelView(_ reelView: ReelView, didSelectElement element: SlotElement)
}

class ReelView: UIView {
    
    private let slotHorizontalMargin: CGFloat = 8.0
    private let spaceBetweenSlots: CGFloat = 8.0
    private var slots = [SlotView]()
    private var animationSpeed: CGFloat = 0.0
    private var animating: Bool = false
    weak var dataSource: ReelViewDataSource?
    weak var delegate: ReelViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 2.0
        clipsToBounds = true
    }
    
    // MARK: slots creation
    
    func fillWithSlots() {
        createSlots()
        centerSlots(animated: false, completion: nil)
    }
    
    private func slotInitialOffset() -> CGFloat {
        return -bounds.height * 0.5
    }
    
    private func slotsEndingOffset() -> CGFloat {
        return bounds.height * 1.25
    }
    
    private func createSlots() {
        let size = slotSize()
        var origin = CGPoint(x: slotHorizontalMargin, y: slotInitialOffset())
        var slotIndex = 0
        
        while origin.y < slotsEndingOffset() {
            let frame = CGRect(origin: origin, size: size)
            let slotView = SlotView(frame: frame)
            slotView.slotElement = dataSource?.getElement(forReel: self, atIndex: slotIndex)
            addSubview(slotView)
            slots.append(slotView)
            origin.y += (size.height + spaceBetweenSlots)
            slotIndex += 1
        }
    }
    
    private func centerSlots(animated: Bool, completion: ((Void) -> Void)?) {
        let centerSlot = middleSlot()
        let verticalOffset = bounds.midY - centerSlot.frame.midY
        
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 1.0,
                           options: [],
                           animations: {
                            for slot in self.slots {
                                slot.frame.origin.y += verticalOffset
                            }
            }, completion: { _ in
                completion?()
            })
        } else {
            for slot in slots {
                slot.frame.origin.y += verticalOffset
            }
        }
    }
    
    private func middleSlot() -> SlotView {
        let reelVerticalCenter = bounds.midY
        
        let sortedByDistance = slots.sorted { (left: SlotView, right: SlotView) -> Bool in
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
        
        guard !animating else {
            return
        }
        
        animating = true
        animationSpeed = speed
        
        for slot in slots {
            startAnimation(forSlot: slot)
        }
    }
    
    func stopAnimation() {
        guard animating else {
            return
        }
        
        animating = false
        for slot in slots {
            if let presentationLayer = slot.layer.presentation() {
                slot.frame = presentationLayer.frame
            }
            slot.layer.removeAllAnimations()
        }
        
        centerSlots(animated: true, completion: {
            guard let element = self.middleSlot().slotElement else {
                return
            }
            self.delegate?.reelView(self, didSelectElement: element)
        })
    }
    
    private func startAnimation(forSlot slot: SlotView) {
        let duration = animationDuration(forSlot: slot)
        animate(slot: slot, withDuration: duration)
    }
    
    private func getAnimationDuration(forDistance distance: CGFloat) -> TimeInterval {
        return TimeInterval(distance / animationSpeed)
    }
    
    private func animate(slot: SlotView, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            slot.frame.origin.y = self.slotsEndingOffset()
        }, completion: { (completed: Bool) in
            guard self.animating else { return }
            self.startRepeatAnimation(forSlot: slot)
        })
    }
    
    private func animationDuration(forSlot slot: SlotView) -> TimeInterval {
        let distance = slotsEndingOffset() - slot.frame.minY
        return getAnimationDuration(forDistance: distance)
    }
    
    private func startRepeatAnimation(forSlot slot: SlotView) {
        setSlotAboveTopSlot(slot: slot)
        let duration = animationDuration(forSlot: slot)
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: [.curveLinear],
                       animations: {
            slot.frame.origin.y = self.slotsEndingOffset()
        }, completion: { (_) in
            guard self.animating else { return }
            self.startRepeatAnimation(forSlot: slot)
        })
    }
    
    private func setSlotAboveTopSlot(slot: UIView) {
        let presentationLayers = slots.flatMap { $0.layer.presentation() }
        
        let sorted = presentationLayers.sorted { (left: CALayer, right: CALayer) -> Bool in
            return left.frame.minY < right.frame.minY
        }
        
        let topLayer = sorted[0]
        slot.frame.origin.y = topLayer.frame.minY - slot.bounds.height - spaceBetweenSlots
    }
}
