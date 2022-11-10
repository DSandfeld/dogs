//
//  FavoritesCollectionViewController.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 09/11/2022.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesCollectionViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var collectionViewLayout: UICollectionViewFlowLayout {
        get {
            let collectionFlowLayout = UICollectionViewFlowLayout()
            collectionFlowLayout.scrollDirection = .vertical
            collectionFlowLayout.minimumInteritemSpacing = 1
            collectionFlowLayout.minimumLineSpacing = 1
            collectionFlowLayout.itemSize = CGSize(width: view.bounds.width / 3 - 1, height: view.bounds.width / 3 - 1)
            return collectionFlowLayout
        }
    }
    
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var viewModel: FavoritesCollectionViewViewModel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel?.title
        
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: "favoritesCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBindings()
    }
    
    func setupBindings() {
        viewModel?.imageLinks.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "favoritesCell", cellType: FavoritesCollectionViewCell.self)) { row, link, cell in
                
                DataProvider.shared.getImageFromLocal( link, callback: { data in
                    guard let data else { return }
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
                })
                
                cell.titleLabel.text = StorageManager.shared.favoriteBreeds[row]
            }
            .disposed(by: disposeBag)
    }
    
}
