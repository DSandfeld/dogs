//
//  MainViewViewModel.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 05/12/2024.
//

import Foundation
import RxCocoa
import RxSwift

class MainViewViewModel {
    
    let racesSubject = BehaviorSubject<[(String, String?)]>(value: [])
    
    
    public func getAllBreeds() {
        DataProvider.shared.getDogBreeds { result in
            
            switch result {
            case .success(let response):
                
                var dogs: [SubbreedDog] = response.message.map({ key, value in
                    return (BasicDog(breed: key), value)
                }).flatMap { basicDog, subbreeds in
                    var customBreeds = [SubbreedDog]()
                    subbreeds.forEach { subbreed in
                        customBreeds.append(SubbreedDog(breed: basicDog.breed, subbreed: subbreed))
                    }
                    return customBreeds
                }
                
                dogs = dogs.sorted(by: { $0 < $1 })
                
                var racesWithSubbreeds = [(String, String?)]()
                
                dogs.forEach { race in
                    racesWithSubbreeds.append((race.breed, race.subbreed))
                }
                
                self.racesSubject.onNext(racesWithSubbreeds)
                
            case .failure(let error):
                debugPrint(error)
                self.racesSubject.onNext([])
                // TODO: Show an alert pop-up
                
            case .none:
                break
            }
            
        }
    }
    
}
