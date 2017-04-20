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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reelsContainerView.setupViews()
        reelsContainerView.randomizationAlgorithm = SpeedRandomizationAlgorithm(minValue: 200.0, maxValue: 400.0)
    }
    
    // MARK: UI Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        reelsContainerView.startReelsAnimation()
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        
    }

}

