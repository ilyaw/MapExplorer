//
//  Button.swift
//  MapExplorer
//
//  Created by Ilya on 18.06.2022.
//

import Foundation
import UIKit

class Button: UIButton {
        
    init(title: String?,
         backgroundColor: UIColor = .orange,
         cornerRadius: CGFloat = 10) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(.gray, for: .disabled)
        self.setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
