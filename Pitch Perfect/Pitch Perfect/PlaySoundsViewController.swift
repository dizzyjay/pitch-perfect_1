//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by dj fant on 4/1/15.
//  Copyright (c) 2015 djfant. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    //globals
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    //system event functions
    override func viewDidLoad() {
        //runs at load
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
            var filePathUrl = NSURL.fileURLWithPath(filePath)
            audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        }else{
            println("the filePath is empty")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //user defined actions
    @IBAction func playFast(sender: UIButton) {
        playReset()
        audioPlayer.enableRate = true
        audioPlayer.rate = 2.0
        audioPlayer.play()
    }

    @IBAction func playSlow(sender: UIButton) {
        playReset()
        audioPlayer.enableRate = true
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    @IBAction func playStop(sender: UIButton) {
        playReset()
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playReset()
        playAudioWithVariablePitch(1000)
        
    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playReset()
        playAudioWithVariablePitch(-1000)
    }
    
    //user defined functions
    func playReset(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
}
