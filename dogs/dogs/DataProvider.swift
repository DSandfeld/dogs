//
//  DataProvider.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 08/11/2022.
//

import Foundation

class DataProvider {
    
    static let shared = DataProvider()
    
    private let baseAPIstring = "https://dog.ceo/api/breed/"
    private let randomString = "/images/random"
    private let listString = "/images/list"
    
    private var imageTask: URLSessionDataTask?
    
    private init() {}
    
    func getAllBreeds(callback: @escaping ([(String, String?)]) -> ()) {
        var racesWithSubbreeds: [(String, String?)] = []
        
        if let url = URL(string: "https://dog.ceo/api/breeds/list/all") {
            URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                guard let data else { return }
                
                if let dict = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, AnyObject>, let dogs = dict["message"] {
                    
                    if let races = dogs.keyEnumerator().allObjects as? [String] {
                        races.forEach { race in
                            if let subbreeds = dogs[race] as? [String], subbreeds.count > 0 {
                                subbreeds.forEach { subbreed in
                                    racesWithSubbreeds.append((race, subbreed))
                                }
                            } else {
                                racesWithSubbreeds.append((race, nil))
                            }
                        }
                        callback(racesWithSubbreeds)
                    }
                }
            }).resume()
        }
    }
    
    func getRandomImageFor(_ breed: String, subbreed: String?, callback: @escaping (Data?) -> ()) {
        var urlString = "\(baseAPIstring)\(breed)\(randomString)"
        
        if let subbreed {
            urlString = "\(baseAPIstring)\(breed)/\(subbreed)\(randomString)"
        }
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 {
                    
                    if let data = data, let dict = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, AnyObject>, let message = dict["message"] as? String, let newUrl = URL(string: message) {
                        
                        URLSession.shared.dataTask(with: newUrl) { data, response, error in
                            if let data = data {
                                callback(data)
                            }
                        }.resume()
                    }
                }
            }.resume()
        }
    }
    
    func imageLinks(_ breed: String, subbreed: String?, callback: @escaping ([String]) -> ()) {
        var urlString = "\(baseAPIstring)\(breed)/images"
        
        if let subbreed {
            urlString = "\(baseAPIstring)\(breed)/\(subbreed)/images"
        }
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 {
                    
                    if let data = data, let dict = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, AnyObject> {
                        if let message = dict["message"] as? [String] {
                            callback(message)
                        }
                    }
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
