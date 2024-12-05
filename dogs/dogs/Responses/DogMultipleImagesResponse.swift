//
//  DogMultipleImagesResponse.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 05/12/2024.
//

import Foundation

struct DogMultipleImagesResponse: Decodable {
    
    let message: [String]
    let status: String
    
}
