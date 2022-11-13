//
//  StorageManager.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 09/11/2022.
//

import Foundation
import UIKit

class StorageManager {
    
    var favoriteBreeds: [(String, Int)] = []
    
    var searchPath: String {
        get {
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            return paths.first!
        }
    }
    
    static let shared = StorageManager()
    
    init() { }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveToDocuments(image: UIImage, breed: String, index: Int, withSucces: (Bool) -> ()) {
        let storagePath = StorageManager.shared.getDocumentsDirectory()
        let savingScheme = "\(breed)-\(index)"
        let fileUrl = storagePath.appendingPathComponent("\(savingScheme).png")
        
        if let imageData = image.pngData(), let _ = try? imageData.write(to: fileUrl) {
            withSucces(true)
        } else {
            withSucces(false)
        }
    }
    
    func removeFromDocuments(breed: String, atIndex: Int) {
        do {
            let file = "\(breed)-\(atIndex).png"
            try FileManager.default.removeItem(at: getDocumentsDirectory().appendingPathComponent(file))

            favoriteBreeds.removeAll { favoriteBreed in
                let match = favoriteBreed.0.elementsEqual(breed) && favoriteBreed.1 == atIndex
                return match
            }
        } catch {
            print("could not find and delete file")
        }
    }
    
    func isItFavorite(breed: String, index: Int) -> Bool {
        guard let items = try? FileManager.default.contentsOfDirectory(atPath: searchPath) else { return false }
        let isItFavorite = items.contains("\(breed)-\(index).png")
        return isItFavorite
    }
    
    func getFavoritesFromDocuments() -> [String] {
        if var items = try? FileManager.default.contentsOfDirectory(atPath: searchPath) {
            var i = 0
            items.forEach { image in
                let extentedPath = searchPath.appending("/\(image)")
                let replacedString = extentedPath.replacingOccurrences(of: " ", with: "%20")
                
                let nameComponents = image.components(separatedBy: "-")
                if let breed = nameComponents.first, let last = nameComponents.last {
                    let indexAndFileType = last.components(separatedBy: ".")
                    if let indexOfImage = indexAndFileType.first, let indexInt = Int(indexOfImage) {
                        favoriteBreeds.append((breed, indexInt))
                    }
                }
                
                items.insert(replacedString, at: i)
                items.remove(at: i+1)
                i += 1
            }
            return items
        }
        
        return []
    }
    
}
