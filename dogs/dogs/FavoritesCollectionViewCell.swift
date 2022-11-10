//
//  FavoritesCollectionViewCell.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 09/11/2022.
//

import UIKit

class FavoritesCollectionViewCell: CollectionViewCell {
    
    var titleLabel: UILabel = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .white
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
}
