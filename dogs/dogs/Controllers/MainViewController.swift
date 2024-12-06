//
//  ViewController.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 04/11/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    private let viewModel = MainViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("mainview_nav_title", comment: "")
        
        let favoritesBarButton = UIBarButtonItem(systemItem: .bookmarks)
        favoritesBarButton.target = self
        favoritesBarButton.action = #selector(goToFavorites)
        navigationItem.rightBarButtonItem = favoritesBarButton
        
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(tableView)
        
        tableView.dataSource = nil
        tableView.register(DogTableViewCell.self, forCellReuseIdentifier: "mainDogCell")
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.racesSubject.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "mainDogCell",
                                         cellType: DogTableViewCell.self)) { row, element, cell in
                cell.configureTitle(with: element.0, subbreed: element.1)
            }
                                         .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .withLatestFrom(viewModel.racesSubject) { ($0.0, $0.1, $1) }
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .subscribe(onNext: { cell, indexPath, races in
                guard let dogCell = cell as? DogTableViewCell else { return }
                
                if let subbreed = races[indexPath.row].1 {
                    dogCell.configureImage(with: races[indexPath.row].0, subbreed: subbreed)
                } else {
                    dogCell.configureImage(with: races[indexPath.row].0)
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withLatestFrom(viewModel.racesSubject) { ($0, $1) }
            .subscribe { indexPath, selectedBreed in
                
                let mainBreed = selectedBreed[indexPath.row].0
                let subbreed = selectedBreed[indexPath.row].1
                
                let imageGalleryVC = DetailsCollectionViewController()
                let imageGalleryVM = DetailsCollectionViewViewModel(breed: mainBreed, subbreed: subbreed)
                imageGalleryVC.viewModel = imageGalleryVM
                
                self.navigationController?.pushViewController(imageGalleryVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        viewModel.getAllBreeds()
    }
    
    @objc func goToFavorites(_ sender: UIEvent) {
        let favoritesVC = FavoritesCollectionViewController()
        let favoritesVM = FavoritesCollectionViewViewModel()
        favoritesVC.viewModel = favoritesVM
        
        self.navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
