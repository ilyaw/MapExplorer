//
//  UIStackView+.swift
//  MapExplorer
//
//  Created by Ilya on 18.06.2022.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
