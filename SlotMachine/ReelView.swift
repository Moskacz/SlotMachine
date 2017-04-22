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
    func getElement(forIndex index: Int) -> SlotElement
}

protocol ReelViewDelegate: class {
    func reelView(_ reelView: ReelView, didSelectElement element: SlotElement)
}

class ReelView: UIView {
    
    private let slotHorizontalMargin: CGFloat = 8.0
    private let spaceBetweenSlots: CGFloat = 8.0
    private var visibleSlots = [SlotView]()
    private var animationSpeed: CGFloat = 0.0
    private var animating: Bool = false
    weak var dataSource: ReelViewDataSource?
    weak var delegate: ReelViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 2.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
    
    // MARK: slots creation
    
    func fillWithSlots() {
        createSlots()
        centerSlots(animated: false, completion: nil)
    }
    
    private func createSlots() {
        let size = slotSize()
        var origin = CGPoint(x: slotHorizontalMargin, y: -size.height)
        var slotIndex = 0
        
        while origin.y < bounds.maxY {
            let frame = CGRect(origin: origin, size: size)
            let slotView = SlotView(frame: frame)
            slotView.slotElement = dataSource?.getElement(forIndex: slotIndex)
            addSubview(slotView)
            visibleSlots.append(slotView)
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
                            for slot in self.visibleSlots {
                                slot.frame.origin.y += verticalOffset
                            }
            }, completion: { _ in
                completion?()
            })
        } else {
            for slot in self.visibleSlots {
                slot.frame.origin.y += verticalOffset
            }
        }
    }
    
    private func middleSlot() -> SlotView {
        let reelVerticalCenter = bounds.midY
        
        let sortedByDistance = visibleSlots.sorted { (left: SlotView, right: SlotView) -> Bool in
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
        for slot in visibleSlots {
            startAnimation(forSlot: slot)
        }
    }
    
    func stopAnimation() {
        guard animating else {
            return
        }
        
        animating = false
        for slot in visibleSlots {
            slot.frame = slot.layer.presentation()!.frame
            slot.layer.removeAllAnimations()
        }
        
        centerSlots(animated: true, completion: {
            guard let element = self.middleSlot().slotElement else {
                return
            }
            
            self.delegate?.reelView(self, didSelectElement: element)
        })
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
            guard self.animating else {
                return
            }
            
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
            guard self.animating else {
                return
            }
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
