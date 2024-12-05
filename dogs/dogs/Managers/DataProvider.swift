//
//  DataProvider.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 08/11/2022.
//

import Foundation

enum DogListError: Error {
    case failedToFetchList
}

enum ImageError: Error {
    case noResponseFromServer
    case couldNotLoadImage
    case failedToLoadImages
}

class DataProvider {
    
    static let shared = DataProvider()
    
    private let baseAPIstring = "https://dog.ceo/api/breed/"
    private let randomString = "/images/random"
    private let listString = "/images/list"
    private let allBreedsLink = "https://dog.ceo/api/breeds/list/all"
    
    private var imageTask: URLSessionDataTask?
    
    private init() {}
    
    func getDogBreeds(callback: @escaping (Result<DogBreedResponse, DogListError>?) -> ()) {
        
        if let url = URL(string: allBreedsLink) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
                if let data, let response = try? JSONDecoder().decode(DogBreedResponse.self, from: data) {
                    callback(.success(response))
                } else {
                    callback(.failure(.failedToFetchList))
                }
            }).resume()
        }
    }
    
    func getRandomImageFor(_ breed: String, subbreed: String?, callback: @escaping (Result<Data, ImageError>?) -> ()) {
        var urlString = "\(baseAPIstring)\(breed)\(randomString)"
        
        if let subbreed {
            urlString = "\(baseAPIstring)\(breed)/\(subbreed)\(randomString)"
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data, let response = try? JSONDecoder().decode(DogSingleImageResponse.self, from: data), let imageUrl = URL(string: response.message) {
                    URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                        if let data {
                            callback(.success(data))
                        } else {
                            callback(.failure(.failedToLoadImages))
                        }
                    }.resume()
                } else {
                    callback(.failure(.couldNotLoadImage))
                }
            }.resume()
        }
    }
    
    func imageLinks(_ breed: String, subbreed: String?, callback: @escaping (Result<DogMultipleImagesResponse, ImageError>?) -> ()) {
        var urlString = "\(baseAPIstring)\(breed)/images"
        
        if let subbreed {
            urlString = "\(baseAPIstring)\(breed)/\(subbreed)/images"
        }
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data, let response = try? JSONDecoder().decode(DogMultipleImagesResponse.self, from: data) {
                    callback(.success(response))
                } else {
                    callback(.failure(.failedToLoadImages))
                }
                
            }.resume()
        }
    }
    
    func getImageFromLocal(_ link: String, callback: @escaping (Data?) -> ()) {
        if let url = URL(string: "file://\(link)") {
            if let imageData = try? Data(contentsOf: url) {
                callback(imageData)
            }
        }
    }
    
    func getImage(from link: String, callback: @escaping (Data?) -> ()) {
        if let url = URL(string: link) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 {
                    if let data = data {
                        callback(data)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }
    
}
