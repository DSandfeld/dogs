//
//  CollectionViewCell.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 08/11/2022.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    
    var dogImageView = UIImageView(frame: .zero)
    var favoriteImageView: UIImageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dogImageView.translatesAutoresizingMaskIntoConstraints = false
        dogImageView.contentMode = .scaleAspectFill
        dogImageView.clipsToBounds = true
        addSubview(dogImageView)
        
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteImageView.image = UIImage(named: "star")
        addSubview(favoriteImageView)
        
        NSLayoutConstraint.activate([
            dogImageView.topAnchor.constraint(equalTo: topAnchor),
            dogImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dogImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dogImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            bottomAnchor.constraint(equalToSystemSpacingBelow: favoriteImageView.bottomAnchor, multiplier: 0.5),
            trailingAnchor.constraint(equalToSystemSpacingAfter: favoriteImageView.trailingAnchor, multiplier: 0.5),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 20),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func toggleFavorite(isFavorite: Bool) {
        let template = favoriteImageView.image?.withRenderingMode(.alwaysTemplate)
        favoriteImageView.image = template
        if isFavorite == false {
            favoriteImageView.tintColor = .black
        } else {
            favoriteImageView.tintColor = .white
        }
    }
}
