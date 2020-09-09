//
//  Array+Only.swift
//  Memorize
//
//  Created by Mike Kurkin on 09.09.2020.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
