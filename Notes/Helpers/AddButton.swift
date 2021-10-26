//
//  AddButton.swift
//  Notes
//
//  Created by Владислав Седенков on 26.10.2021.
//

import UIKit

class AddButton: UIButton {
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .orange
        titleLabel?.font = UIFont.systemFont(ofSize: 30)
        setTitle("+", for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = frame.width / 2.0
        setTitleColor(.systemOrange, for: .highlighted)
    }
}
