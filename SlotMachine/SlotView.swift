//
//  SlotView.swift
//  SlotMachine
//
//  Created by Michał Moskała on 19.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import UIKit

class SlotView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.orange
        layer.cornerRadius = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
