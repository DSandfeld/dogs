//
//  NetworkInterface.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 06/12/2024.
//

import Foundation

protocol NetworkInterface {
    
    func getDogBreeds(callback: @escaping (Result<DogBreedResponse, DogListError>?) -> ())
    func getRandomImageFor(_ breed: String, subbreed: String?, callback: @escaping (Result<Data, ImageError>?) -> ())
    func imageLinks(_ breed: String, subbreed: String?, callback: @escaping (Result<DogMultipleImagesResponse, ImageError>?) -> ())
    func getImage(from link: String, callback: @escaping (Data?) -> ())
    
}
