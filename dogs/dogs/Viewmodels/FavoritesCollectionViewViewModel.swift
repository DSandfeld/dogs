//
//  FavoritesCollectionViewViewModel.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 09/11/2022.
//

import RxSwift
import RxCocoa

class FavoritesCollectionViewViewModel {
    
    var imageLinks = BehaviorSubject<[String]>(value: [])
    
    init() {
        let links = StorageManager.shared.getFavoritesFromDocuments()
        imageLinks.onNext(links)
    }
    
}
