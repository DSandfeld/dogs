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
    
    static let shared = StorageManager()
    
    init() { }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveToDocuments(image: UIImage, title: String, indexPath: IndexPath, withSucces: (Bool) -> ()) {
        let storagePath = StorageManager.shared.getDocumentsDirectory()
        let savingScheme = "\(title)-\(indexPath.row)"
        let fileUrl = storagePath.appendingPathComponent("\(savingScheme).png")
        
        if let imageData = image.pngData(), let _ = try? imageData.write(to: fileUrl) {
            withSucces(true)
        } else {
            withSucces(false)
        }
    }
    
    func getFavoritesFromDocuments() -> [String] {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if let dirPath = paths.first, var items = try? FileManager.default.contentsOfDirectory(atPath: dirPath) {
            var i = 0
            items.forEach { image in
                let storagePath = dirPath
                let extentedPath = storagePath.appending("/\(image)")
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
