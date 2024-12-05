//
//  Dog.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 05/12/2024.
//

import Foundation

class BasicDog: Comparable, CustomStringConvertible {
    
    let breed: String
    
    init(breed: String) {
        self.breed = breed
    }
    
    var description: String {
        return breed
    }
    
    static func < (lhs: BasicDog, rhs: BasicDog) -> Bool {
        return lhs.breed < rhs.breed
    }
    
    static func == (lhs: BasicDog, rhs: BasicDog) -> Bool {
        return lhs.breed == rhs.breed
    }
    
}
