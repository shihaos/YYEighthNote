//
//  YYEighthNoteScene.swift
//  YYEighthNote
//
//  Created by yuyuan on 17/3/13.
//  Copyright © 2017年 yuyuan. All rights reserved.
//

import UIKit

public class YYEighthNoteScene: UIView {
    var canMove: Bool = true
    var beginView: UIView = UIView()
    var bgView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        restart()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

   public func moveWithSpeed(speed: CGFloat) -> Void {
        if self.canMove == false {
            return
        }
    
        if (self.beginView.frame.origin.x > -2.01 * Utilities.screenWidth) {
            UIView.animate(withDuration: 0.1) {
                self.beginView.frame = self.moveLeft(left: speed, frame: self.beginView.frame)
                self.bgView.frame = self.moveLeft(left: speed, frame: self.bgView.frame)
            }
        } else {
            let tempView = self.beginView
            self.beginView = self.bgView;
            self.bgView = tempView;
            self.bgView.frame = CGRect(x: self.beginView.frame.maxX, y: 0, width: 2 * Utilities.screenWidth , height: 128);
            
            self.clearAllCliffsForView(bgView: self.bgView)
            self.addCliffToBgView(bgView: self.bgView)
        }
    }
   
    public func fallDownInDistance(distance: CGFloat) -> Bool {
        let catWidth: CGFloat = 50
        for cliffView in self.beginView.subviews {
            let cliffMinX = cliffView.frame.origin.x + self.beginView.frame.origin.x
            let cliffMaxX = cliffMinX + cliffView.frame.size.width
            if distance >= cliffMinX && distance <= (cliffMaxX - catWidth) {
                return true
            }
        }
        
        return false
    }
    
    public func restart() -> Void {
        self.canMove = true

        self.beginView.removeFromSuperview()
        self.bgView.removeFromSuperview()
        
        self.beginView.backgroundColor = UIColor.black
        self.beginView.frame = CGRect(x: 0, y: 0, width: 2 * Utilities.screenWidth, height: 128)
        
        self.bgView.backgroundColor = UIColor.black
        self.bgView.frame = CGRect(x: 2 * Utilities.screenWidth, y: 0, width: 2 * Utilities.screenWidth, height: 128)
        
        self.addSubview(self.beginView)
        self.addSubview(self.beginView)
        
        self.addCliffForbeginView(view: self.beginView)
        self.addCliffToBgView(bgView: self.bgView)
    }
}

extension YYEighthNoteScene {
    fileprivate func addCliffForbeginView(view: UIView) -> Void {
        let randNumber: UInt32 = 1 + arc4random() % 3
        let averageWidth: CGFloat = 1.5 * Utilities.screenWidth / CGFloat(randNumber)
        
        for i in 0..<randNumber {
            let cliffWidth: CGFloat = 70 + CGFloat(arc4random() % 100) * 0.01 * 0.2 * averageWidth
            let gap: CGFloat = averageWidth - cliffWidth;
            let gapX: CGFloat = gap * (CGFloat(arc4random() % 100) * 0.01) +  CGFloat(i) * averageWidth + 0.5 * Utilities.screenWidth
            
            let cliffView = UIView()
            cliffView.frame = CGRect(x: gapX, y: 0, width: cliffWidth, height: 128)
            cliffView.backgroundColor = UIColor.white
            view.addSubview(cliffView)
        }
    }
    
    fileprivate func addCliffToBgView(bgView: UIView) -> Void {
        let randNumber: UInt32 = 2 + arc4random() % 5
        let averageWidth: CGFloat = 2 * Utilities.screenWidth / CGFloat(randNumber)
        
        for i in 0..<randNumber{
            let cliffWidth: CGFloat = 70 + CGFloat(arc4random() % 100) * 0.01 * 0.2 * averageWidth
            let gap: CGFloat = averageWidth - cliffWidth;
            let gapX: CGFloat = gap * (CGFloat(arc4random() % 100) * 0.01) +  CGFloat(i) * averageWidth
            
            let cliffView = UIView()
            cliffView.frame = CGRect(x: gapX, y: 0, width: cliffWidth, height: 128)
            cliffView.backgroundColor = UIColor.white
            bgView.addSubview(cliffView)
        }
    }
    
    fileprivate func clearAllCliffsForView(bgView: UIView) -> Void {
        for view in bgView.subviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate func moveLeft(left: CGFloat, frame: CGRect) -> CGRect {
        let rect = CGRect(x: frame.origin.x - left, y: frame.origin.y, width: 2 * Utilities.screenWidth, height: 128)
        return rect
    }
}

