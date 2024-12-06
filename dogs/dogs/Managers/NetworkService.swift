//
//  NetworkService.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 08/11/2022.
//

import Foundation

class NetworkService: NetworkInterface {
    
    static let shared = NetworkService()
    
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
            // TODO: return the task, so that it can be cancelled if needed
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
