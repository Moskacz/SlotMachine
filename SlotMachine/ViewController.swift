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
        reelsContainerView.setupViews()
        reelsContainerView.randomizationAlgorithm = SpeedRandomizationAlgorithm(minValue: 300.0,
                                                                                maxValue: 400.0)
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

