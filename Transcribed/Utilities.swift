//
//  Utilities.swift
//  Transcribed
//
//  Created by Dan Lindsay on 2017-03-08.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit

class Utilities {
    
    static func getDocsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        
        return docsDirect
    }
    
    static func getAudioFileUrl() -> URL? {
        do {
            let audioUrl = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".m4a")
            return audioUrl
        } catch _ {
            return nil
        }
    }
    
    static func getDateAndTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        let timeString = formatter.string(from: date)
        return timeString
    }
}
