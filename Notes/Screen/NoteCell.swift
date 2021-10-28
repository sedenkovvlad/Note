//
//  TableViewCell.swift
//  Notes
//
//  Created by Владислав Седенков on 26.10.2021.
//

import UIKit

final class NoteCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    func configure(at note: Note) {
        let split = note.text.split(separator: "\n", maxSplits: 2, omittingEmptySubsequences: true)
        titleLabel.text = getTitleText(split: split)
        subtitleLabel.text = getSubtitleText(split: split)
        dateLabel.text = dateFormat(from: note.date)
        
    }
    
    //text split
    private func getTitleText(split: [Substring]) -> String {
        if split.count >= 1 {
            return String(split[0])
        }
        return "New Note"
    }
    
    private func getSubtitleText(split: [Substring]) -> String {
        if split.count >= 2 {
            return String(split[1])
        }
        return "No Subtitle text"
    }
    //date formatter
    private func dateFormat(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
}
