//
//  CoreDataHelper.swift
//  Transcribed
//
//  Created by Dan Lindsay on 2017-03-09.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    init() {
        let container = NSPersistentContainer(name: "Transcribed")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("DAN: \(error.localizedDescription)")
            } else {
                print("DAN: core data fine!")
            }
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeTranscription(audioFileUrlString: String, textFileUrlString: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Transcription", in: context)
        let transcription = NSManagedObject(entity: entity!, insertInto: context)
        transcription.setValue(audioFileUrlString, forKey: "audioFileUrlString")
        transcription.setValue(textFileUrlString, forKey: "textFileUrlString")
        
        do {
           try context.save()
            print("DAN: saved")
        } catch {
            
        }
    }
    
    func getTranscriptions() -> [NSManagedObject]? {
        let fetchedReuest: NSFetchRequest<Transcription> = Transcription.fetchRequest()
        
        do {
            let searchResults = try getContext().fetch(fetchedReuest)
            print("DAN: number of results = \(searchResults.count)")
            
            for trans in searchResults as [NSManagedObject] {
                print("DAN: Result: \(trans.value(forKey: "audioFileUrlString"))")
                
            }
            return searchResults as [NSManagedObject]
        } catch {
            return nil
        }
    }
    
}
