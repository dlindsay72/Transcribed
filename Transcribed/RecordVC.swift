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
    var textFileUrl: URL!
    
    var transcribed: Bool = false
    
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordingInProgressIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let utils = Utilities()
        recFileUrl = utils.getAudioFileUrl()
        textFileUrl = utils.getTextFileUrl()
        print("DAN:" + recFileUrl!.absoluteString)
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
                
                audioPlayer?.stop()
                audioPlayer = try AVAudioPlayer(contentsOf: recFileUrl)
                audioPlayer?.play()
                transcribeAudio()
                
            } catch let error {
                print("DAN: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer?.stop()
        
        if(transcribed) {
            CoreDataHelper().storeTranscription(audioFileUrlString: String(describing: recFileUrl) , textFileUrlString: String(describing: textFileUrl))
        }
    }
    
    // MARK: - Transcribe
    func transcribeAudio() {
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: recFileUrl)
        
        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            
            guard let result = result else {
                print("DAN: \(error?.localizedDescription)")
                return
            }
            
            if result.isFinal {
                let text = result.bestTranscription.formattedString
                self.textView.text = text
                
                do {
                    try text.write(to: self.textFileUrl, atomically: true, encoding: String.Encoding.utf8)
                    self.transcribed = true
                } catch {
                    print("text wasn't written")
                }
            }
        }
    }
    
    

}





























