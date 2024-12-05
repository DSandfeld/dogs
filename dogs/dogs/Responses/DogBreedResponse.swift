//
//  DogBreedResponse.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 05/12/2024.
//

import Foundation

typealias DogBreeds = [String: [String]]

struct DogBreedResponse: Decodable {
    
    let message: DogBreeds
    let status: String
    
}
