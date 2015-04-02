//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by dj fant on 4/1/15.
//  Copyright (c) 2015 djfant. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate{    @IBOutlet weak var recordingLbl: UILabel!
    //outlets
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var tapLbl: UILabel!
    
    //global variables
        var audioRecorder: AVAudioRecorder!
        var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        stopBtn.hidden = true
    }
    @IBAction func startRecording(sender: UIButton) {
        tapLbl.hidden = true
        recordingLbl.hidden = false
        stopBtn.hidden = false
        recordBtn.enabled = false
        //record voice
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true) [0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            let filePathUrl = recorder.url
            let title = recorder.url.lastPathComponent
            recordedAudio = RecordedAudio(filePathUrl: filePathUrl, title: title!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("error")
            recordBtn.enabled = true
            stopBtn.hidden = true
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    @IBAction func stopRecording(sender: UIButton) {
        tapLbl.hidden = false
        recordingLbl.hidden = true
        stopBtn.hidden = true
        recordBtn.enabled = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }

}

