//
//  ViewController.swift
//  SlotMachine
//
//  Created by Michał Moskała on 17.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var reelsContainerView: ReelsContainerView!
    @IBOutlet weak var button: UIButton!
    private var animating: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let slotsProvider = RandomSlotsProvider()
        let elements = [slotsProvider.getSlots(), slotsProvider.getSlots(), slotsProvider.getSlots()]
        reelsContainerView.reelsElements = elements
        
        reelsContainerView.setupViews()
        reelsContainerView.randomizationAlgorithm = SpeedRandomizationAlgorithm(minValue: 300.0,
                                                                                maxValue: 500.0)
    }
    
    // MARK: UI Actions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if animating {
            reelsContainerView.stopReels()
            button.setTitle("Start", for: .normal)
            animating = false
        } else {
            reelsContainerView.startReelsAnimation()
            button.setTitle("Stop", for: .normal)
            animating = true
        }
    }
}

