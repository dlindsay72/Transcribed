//
//  Utilities.swift
//  Transcribed
//
//  Created by Dan Lindsay on 2017-03-08.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit

class Utilities {
    
    var DateTimeString: String?
    
    func getDocsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        
        return docsDirect
    }
    
    func getAudioFileUrl() -> URL? {
        if let audioUrl = getDocsDirectory()?.appendingPathComponent(getDateAndTime() + ".m4a") {
            return audioUrl
        } else {
            return nil
        }
        
    }
    
    func getTextFileUrl() -> URL? {
        if let textUrl = getDocsDirectory()?.appendingPathComponent(getDateAndTime() + ".txt") {
            return textUrl
        } else {
            return nil
        }
        
    }
    
    
    
    func getDateAndTime() -> String {
        if let dateT = DateTimeString {
            return dateT
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        let timeString = formatter.string(from: date)
        return timeString
    }
}
