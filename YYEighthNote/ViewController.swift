//
//  ViewController.swift
//  YYEighthNote
//
//  Created by yuyuan on 17/3/13.
//  Copyright © 2017年 yuyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mesure.startRecord()
        
        self.view.addSubview(self.sceneView)
        self.view.addSubview(self.wizard)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate lazy var mesure: YYVocieMesure = {
        let mesure = YYVocieMesure()
        mesure.delegate = self
        
        return mesure
    }()
    
    fileprivate lazy var sceneView: YYEighthNoteScene = {
        let sceneView = YYEighthNoteScene()
        sceneView.frame = CGRect(x: 0, y: Utilities.screenHeight - 128, width: Utilities.screenWidth, height: 128)

        return sceneView
    }()
    
    fileprivate lazy var wizard: YYEightNoteWizard = {
        let wizard = YYEightNoteWizard()
        wizard.frame = CGRect(x: 100, y: Utilities.screenHeight - 128 - 50, width: 50, height: 50)
        wizard.delegate = self
        
        return wizard
    }()
}

extension ViewController: YYVocieMesureDelegate {
    func moveWithSpeed(speed: CGFloat) -> Void {
        sceneView.moveWithSpeed(speed: speed)
        
        if self.wizard.isInSky == false && self.wizard.isAlive == true {
            let isFallen = self.sceneView.fallDownInDistance(distance: 100.0)
            if (isFallen == true) {
                self.sceneView.canMove = false;
                self.wizard.fallDown()
            }
        }
    }
    
    func jumpWithHeight(height: CGFloat) -> Void {
        wizard.jumpWithHeight(height: height)
    }
}

extension ViewController: YYEightNoteWizardDelegate {
    func touchTheGround() -> Void {
        let isFallen = sceneView.fallDownInDistance(distance: 100)
        if isFallen == true {
            self.sceneView.canMove = false
            self.wizard.fallDown()
        }
    }
    
    func fallDownFinishd() -> Void {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: {(Void) in
            self.fallDownFinishdHanlder()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func fallDownFinishdHanlder(){
        sceneView.restart()
        wizard.reStart()
    }
}


