//
//  UIView + Ext.swift
//  MapExplorer
//
//  Created by Ilya on 18.06.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { self.addSubview($0) }
    }
}
