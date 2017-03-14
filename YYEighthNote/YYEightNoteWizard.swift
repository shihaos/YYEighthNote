//
//  YYEightNoteWizard.swift
//  YYEighthNote
//
//  Created by yuyuan on 17/3/14.
//  Copyright © 2017年 yuyuan. All rights reserved.
//

import UIKit

public class YYEightNoteWizard: UIView {
    public var isAlive: Bool = true
    public var isInSky: Bool = false
    weak var delegate: YYEightNoteWizardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func jumpWithHeight(height: CGFloat) -> Void {
        if isAlive == false {
            return
        }
        
        isAlive = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - height*10, width: 50, height: 50);
        }, completion: {(finished: Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + height*10, width: 50, height: 50);
            }, completion: {(finished: Bool) in
                self.delegate?.touchTheGround()
                self.isInSky = false
            })
        })
    }
    
    public func fallDown() -> Void {
        isAlive = false
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: self.frame.origin.x, y: Utilities.screenHeight, width: 50, height: 50);
        }, completion: {(finished: Bool) in
            self.delegate?.fallDownFinishd()
        })
        
    }
    
    public func reStart() -> Void {
        self.frame = CGRect(x: self.frame.origin.x, y: Utilities.screenHeight - 128 - 50, width: 50, height: 50);
        isAlive = true
    }
}

@objc public protocol YYEightNoteWizardDelegate: NSObjectProtocol {
    func touchTheGround()
    func fallDownFinishd()
}

