//
//  Note.swift
//  Notes
//
//  Created by Владислав Седенков on 26.10.2021.
//

import Foundation

class Note: Equatable, Codable {
    var text: String
    var date: Date
    
    init(text: String, date: Date) {
        self.text = text
        self.date = date
    }
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.date == rhs.date
    }
    
   
}
