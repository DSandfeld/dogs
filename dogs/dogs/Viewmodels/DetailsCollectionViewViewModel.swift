//
//  CollectionViewViewModel.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 08/11/2022.
//

import RxSwift
import RxCocoa

class DetailsCollectionViewViewModel {
    
    var breed: String
    var subbreed: String?
    var imageLinks = BehaviorSubject<[String]>(value: [])
    
    var title: String {
        get {
            if let subbreed {
                return "\(subbreed) \(breed)"
            } else {
                return breed
            }
        }
    }
    
    init(breed: String, subbreed: String?) {
        self.breed = breed
        self.subbreed = subbreed
        
        DataProvider.shared.imageLinks(breed, subbreed: subbreed) { links in
            self.imageLinks.onNext(links)
        }
    }
    
}
