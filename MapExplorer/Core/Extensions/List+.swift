//
//  List+.swift
//  MapExplorer
//
//  Created by Ilya on 20.06.2022.
//

import Foundation
import RealmSwift

extension List {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}
