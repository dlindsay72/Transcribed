//
//  TranscriptionsVC.swift
//  Transcribed
//
//  Created by Dan Lindsay on 2017-03-08.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import CoreData

class TranscriptionsVC: UITableViewController {
    
    var transcriptions: [NSManagedObject] = [NSManagedObject]()
    var reuseIdentifier = "transcriptionsTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        checkPermissions()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let results = CoreDataHelper().getTranscriptions() {
            transcriptions = results
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transcriptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let transc = transcriptions[indexPath.row]

        cell.textLabel?.text = String(describing: transc.value(forKey: "audioFileUrlString"))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Permissions
    func checkPermissions () {
        let recAuthorized = AVAudioSession.sharedInstance().recordPermission() == .granted
        let transAuthorized = SFSpeechRecognizer.authorizationStatus() == .authorized
        let authorized = recAuthorized && transAuthorized
        
        if !authorized {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionsVC") {
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
 

}






























