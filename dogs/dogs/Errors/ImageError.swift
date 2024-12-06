//
//  ImageError.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 06/12/2024.
//

import Foundation

enum ImageError: Error {
    case noResponseFromServer
    case couldNotLoadImage
    case failedToLoadImages
}
