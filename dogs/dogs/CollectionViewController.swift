//
//  CollectionViewController.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 08/11/2022.
//

import UIKit
import RxSwift
import RxCocoa

class CollectionViewController: UIViewController {
    
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
    
    var viewModel: CollectionViewViewModel?
    
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
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
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
            .bind(to: collectionView.rx.items(cellIdentifier: "collectionCell", cellType: CollectionViewCell.self)) { row, link, cell in
                
                DataProvider.shared.getImage(from: link, callback: { data in
                    guard let data else { return }
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
                })
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cellAtIndexPath = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            let imageViewFromCell = cellAtIndexPath.imageView
            
            guard let image = imageViewFromCell.image, let title else { return }
            
            // saving it to photos of the device
            //UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            
            // this will save to the app documents
            StorageManager.shared.saveToDocuments(image: image, title: title, indexPath: indexPath) { success in
                var ac = UIAlertController()
                if !success {
                    ac = UIAlertController(title: "Save error", message: "Could not save at this time.", preferredStyle: .alert)
                } else {
                    ac = UIAlertController(title: "Saved!", message: "This photo has been saved to your favorites.", preferredStyle: .alert)
                }
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        
    }
    
}

// photo handling
extension CollectionViewController {
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        var ac = UIAlertController()
        if let error = error {
            ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
        } else {
            ac = UIAlertController(title: "Saved!", message: "This photo has been saved to your favorites.", preferredStyle: .alert)
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}
