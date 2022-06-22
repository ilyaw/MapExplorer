//
//  Results+.swift
//  MapExplorer
//
//  Created by Ilya on 19.06.2022.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}
