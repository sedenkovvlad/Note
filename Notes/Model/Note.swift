//
//  Note.swift
//  Notes
//
//  Created by Владислав Седенков on 26.10.2021.
//

import Foundation

class Note: NSObject, Codable {
    
    var text: String
    var date: Date
    
    init(text: String, date: Date) {
        self.text = text
        self.date = date
    }
}
