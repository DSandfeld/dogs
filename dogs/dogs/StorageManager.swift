//
//  StorageManager.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 09/11/2022.
//

import Foundation
import UIKit

class StorageManager {
    
    var favoriteBreeds: [String] = []
    
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
        } catch {
            print("someting happened")
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
                if let breed = nameComponents.first {
                    favoriteBreeds.append(breed)
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
