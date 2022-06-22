//
//  String + Ext.swift
//  MapExplorer
//
//  Created by Ilya on 18.06.2022.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
