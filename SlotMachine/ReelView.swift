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
    private var reusableSlots = [UIView]()
    private var animationSpeed: CGFloat = 0.0
    private var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 2.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        clipsToBounds = true
    }
    
    func fillWithSlots() {
        createSlots()
    }
    
    func startAnimation(withSpeed speed: CGFloat) {
        animationSpeed = speed
        guard animationSpeed != 0.0 else {
            return
        }
        
        startRepeatAnimationTimer()
        for slot in visibleSlots {
            startAnimation(forSlot: slot, withSpeed: speed)
        }
    }
    
    private func startAnimation(forSlot slot: UIView, withSpeed speed: CGFloat) {
        let distance = bounds.maxY - slot.frame.minY
        let animationDuration = TimeInterval(distance / speed)
        animate(slot: slot, withDuration: animationDuration)
    }
    
    private func animate(slot: UIView, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            slot.frame.origin.y = self.bounds.maxY
        }, completion: { [weak self] (completed: Bool) in
            self?.removeFromVisible(slot: slot)
            self?.reusableSlots.append(slot)
        })
    }
    
    private func removeFromVisible(slot: UIView) {
        guard let index = visibleSlots.index(of: slot) else {
            return
        }
        
        visibleSlots.remove(at: index)
    }
    
    // MARK: slots creation
    
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
    
    private func slotSize() -> CGSize {
        let reelWidth = bounds.width
        let slotWidth = reelWidth - 2.0 * slotHorizontalMargin
        return CGSize(width: slotWidth, height: slotWidth)
    }
    
    // MARK: timer
    
    private func startRepeatAnimationTimer() {
        let time = DispatchTime.now() + calculateTimerDelay()
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.addSlotAndAnimate()
            let timeInterval = TimeInterval((self.slotSize().height  + self.spaceBetweenSlots) / self.animationSpeed)
            self.timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                              target: self,
                                              selector: #selector(self.addSlotAndAnimate),
                                              userInfo: nil,
                                              repeats: true)
        }
    }
    
    func addSlotAndAnimate() {
        let size = slotSize()
        let frame = CGRect(x: slotHorizontalMargin, y: -size.width, width: size.width, height: size.height)
        
        var slot: UIView
        if reusableSlots.count > 0 {
            slot = reusableSlots.removeFirst()
            slot.frame = frame
        } else {
            slot = SlotView(frame: frame)
        }
        
        addSubview(slot)
        visibleSlots.append(slot)

        startAnimation(forSlot: slot, withSpeed: animationSpeed)
    }
    
    private func calculateTimerDelay() -> TimeInterval {
        guard let lastSlot = visibleSlots.last else {
            return 0.0
        }
        
        let offset = fabs(lastSlot.frame.minY - bounds.maxY) + spaceBetweenSlots
        return TimeInterval(offset / animationSpeed)
    }
}
