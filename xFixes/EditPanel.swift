//
//  EditPanel.swift
//  starter
//
//  Created by Ryad on 09.04.17.
//  Copyright © 2017 Ryad. All rights reserved.
//
//Git
import UIKit

class EditPanel : UIView  {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        initGestureRecognizers()
    }
    
    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan(panGR: )))
        addGestureRecognizer(panGR)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(panGR: )))
        addGestureRecognizer(tapGR)
    }
    
    func didTap(panGR: UITapGestureRecognizer) {
        // added to disable tap on component view
    }
    
    func didPan(panGR: UIPanGestureRecognizer) {
        self.superview!.bringSubview(toFront: self)
        var translation = panGR.translation(in: self)
        translation = translation.applying(self.transform)
        self.center.x += translation.x
        self.center.y += translation.y
        panGR.setTranslation(CGPoint.zero, in: self)
    }
}
