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
    }
    
    
    // MARK: UI Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        reelsContainerView.startReelsAnimation()
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        
    }

}

