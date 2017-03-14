//
//  YYVocieMesure.swift
//  YYEighthNote
//
//  Created by yuyuan on 17/3/13.
//  Copyright © 2017年 yuyuan. All rights reserved.
//

import Foundation
import AVFoundation
import QuartzCore

public class YYVocieMesure: NSObject {
    
    weak var delegate: YYVocieMesureDelegate?
    var audioRecorder: AVAudioRecorder!
    var scaleFactor: Float!
    var table: NSMutableArray!
    var isJumping: Bool = false
    
    let recordSettings = [
        AVSampleRateKey : NSNumber(value: Float(44100.0)),
        AVFormatIDKey : NSNumber(value:Int32(kAudioFormatAppleIMA4)),
        AVEncoderBitDepthHintKey : NSNumber(value: Int32(16)),
        AVNumberOfChannelsKey : NSNumber(value: Int32(1)),
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))
    ]
    
    override init() {
        super.init()
        
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(url: directoryURL()!,
                                                settings: recordSettings)
            audioRecorder.prepareToRecord()
            audioRecorder.isMeteringEnabled = true
        } catch {}
        
        self.setupFactor()
    }
    
    public func startRecord() -> Void {
        let updater = CADisplayLink(target: self, selector: #selector(YYVocieMesure.updateMeasureValue))
        updater.preferredFramesPerSecond = 6
        updater.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        if !audioRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
                
            } catch {}
        }
    }
    
    public func stopRecord() -> Void {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {}
    }
    
    public func updateMeasureValue(){
        audioRecorder.updateMeters()
        
        let power = self.audioRecorder.peakPower(forChannel: 0);
        let peakLevel = self.valueForPower(power: power)
        
        if peakLevel > 0.5 && self.isJumping == false {
            self.isJumping = true
            
            let mainQueue = DispatchQueue.main
            let deadline = DispatchTime.now() + .seconds(2)
            mainQueue.asyncAfter(deadline: deadline) {
                self.isJumping = false
            }
            
            self.delegate?.jumpWithHeight(height: CGFloat(peakLevel*20))
            
        } else if peakLevel > 0.1 {
            self.delegate?.moveWithSpeed(speed: CGFloat(peakLevel*30))
        }
    }
}

extension YYVocieMesure {
    fileprivate func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("temp.caf")
        return soundURL
    }
    
    fileprivate func valueForPower(power: Float) -> Float {
        if (power < -60.0) {
            return 0.0;
        } else if (power >= 0.0) {
            return 1.0;
        } else {
            let index = (Int) (power * scaleFactor);
            return Float(String(describing: table[index]))!;
        }
    }
    
    fileprivate func setupFactor() -> Void {
        let dbResolution = -60.0 / (300 - 1)
        scaleFactor = Float(1.0 / dbResolution)
        
        table = NSMutableArray.init(capacity: 300)
        let minAmp = powf(10.0, 0.05 * -60.0)
        let ampRange = 1.0 - minAmp;
        let invAmpRange = 1.0 / ampRange;
        
        for i in 0..<300 {
            let decibels = Double(i) * dbResolution;
            let amp = powf(10.0, Float(0.05 * decibels));
            let adjAmp = (amp - minAmp) * invAmpRange;
            
            table[i] = adjAmp;
        }
    }
}

@objc public protocol YYVocieMesureDelegate: NSObjectProtocol {
    func moveWithSpeed(speed: CGFloat)
    func jumpWithHeight(height: CGFloat)
}


