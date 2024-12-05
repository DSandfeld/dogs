//
//  SubbreedDog.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 05/12/2024.
//

import Foundation

class SubbreedDog: BasicDog {
    
    let subbreed: String
    
    init(breed: String, subbreed: String) {
        self.subbreed = subbreed
        super.init(breed: breed)
    }
    
    override var description: String {
        return subbreed + " " + breed
    }
}
