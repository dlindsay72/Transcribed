//
//  PermissionsVC.swift
//  Transcribed
//
//  Created by Dan Lindsay on 2017-03-08.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class PermissionsVC: UIViewController {
    
    @IBOutlet weak var permissionsLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // mopves through to transcribe permissions
    func requestRecordPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission () { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    //get transcription permissions
                    self.requestTranscribePermissions()
                } else {
                    //error
                    self.showError()
                }
            }
        }
    }

    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    // great, good to go!
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // error handling
                    self.showError()
                }
            }
        }
    }
    
    func showError() {
        self.permissionsLabel.text = "You have previously denied this app access to speech recognition.  Please change in settings and restart the app."
        self.disableButton()
    }
    
    func disableButton() {
        self.button.isEnabled = false
        UIView.animate(withDuration: 1.0) {
            self.button.alpha = 0.3
        }
        
    }
    
    @IBAction func grantNowPressed(_ sender: Any) {
        requestRecordPermissions()
    }
    

}

