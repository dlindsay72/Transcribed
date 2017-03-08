//
//  RecordVC.swift
//  Transcribed
//
//  Created by Dan Lindsay on 2017-03-08.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class RecordVC: UIViewController, AVAudioRecorderDelegate {
    
    var audioRec: AVAudioRecorder?
    var recFileUrl: URL!
    @IBOutlet weak var recordingInProgressIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recFileUrl = Utilities.getAudioFileUrl()
        print("DAN" + recFileUrl!.absoluteString)
        recordAudio()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Audio Recording
    func recordAudio() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRec = try AVAudioRecorder(url: recFileUrl, settings: settings)
            audioRec?.delegate = self
            audioRec?.record()
            recordingInProgressIndicator.startAnimating()
        } catch let error {
            //failed to record
            print("DAN: \(error.localizedDescription)")
            recordingEnded(false)
        }
    }
    
    @IBAction func stopRecordingPressed(_ sender: UIButton) {
        stopRecording(sender: sender)
    }
    
    func stopRecording(sender: UIButton) {
        audioRec?.stop()
        sender.titleLabel?.text = "Finished"
        sender.isEnabled = false
        sender.alpha = 0.2
        recordingInProgressIndicator.stopAnimating()
        UIView.animate(withDuration: 1.2) { 
            self.recordingInProgressIndicator.alpha = 0
        }
    }
    
    
    // MARK: - Audio Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            recordingEnded(false)
        } else {
            recordingEnded(true)
        }
    }
    
    func recordingEnded(_ success: Bool) {
        audioRec?.stop()
        if success {
            do {
                //transcribe audio
                
            } catch let error {
                print("DAN: \(error.localizedDescription)")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
