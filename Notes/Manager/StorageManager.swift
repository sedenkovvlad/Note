//
//  StorageManager.swift
//  Notes
//
//  Created by Владислав Седенков on 27.10.2021.
//

import Foundation

class StorageManager {
    
    static let notesKey = "myNotes"
    
    static func save(notes: [Note]?) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: notesKey)
        }
    }
    
    static func load() -> [Note] {
        let defaults = UserDefaults.standard
        var notes = [Note]()
        if let data = defaults.object(forKey: notesKey) as? Data {
            let decoder = JSONDecoder()
            notes = (try? decoder.decode([Note].self, from: data)) ?? notes
        }
        return notes
    }
}
