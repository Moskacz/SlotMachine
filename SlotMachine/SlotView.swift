//
//  SlotView.swift
//  SlotMachine
//
//  Created by Michał Moskała on 19.04.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import UIKit

class SlotView: UIView {
    
    private weak var imageView: UIImageView?
    private let imageMargin: CGFloat = 4.0
    
    var slotElement: SlotElement? {
        didSet {
            imageView?.image = slotElement?.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.orange
        layer.cornerRadius = 2.0
        addImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addImageView() {
        let imageView = UIImageView(frame: CGRect.zero)
        addSubview(imageView)
        self.imageView = imageView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageWidth = bounds.width - 2 * imageMargin
        let imageHeight = bounds.height - 2 * imageMargin
        
        imageView?.frame = CGRect(x: imageMargin,
                                  y: imageMargin,
                                  width: imageWidth,
                                  height: imageHeight)
        
    }
    
}
