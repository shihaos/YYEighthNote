//
//  Utilities.swift
//  YYEighthNote
//
//  Created by yuyuan on 17/3/14.
//  Copyright © 2017年 yuyuan. All rights reserved.
//

import UIKit

public class Utilities: NSObject {
    /// get the screen width (x)
    open static var screenWidth: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    
    /// get the screen height (y)
    open static var screenHeight: CGFloat {
        get {
            return UIScreen.main.bounds.size.height
        }
    }
}
