//
//  StorageInterface.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 06/12/2024.
//

import Foundation
import UIKit

protocol StorageInterface {
    
    var favoriteBreeds: [(String, Int)] { get }
    
    func getFavoritesFromDocuments() -> [String]
    func saveToDocuments(image: UIImage, breed: String, index: Int, withSucces: (Bool) -> ())
    func removeFromDocuments(breed: String, atIndex: Int)
    func isItFavorite(breed: String, index: Int) -> Bool
    
    func getImageFromLocal(_ link: String, callback: @escaping (Data?) -> ())
}
