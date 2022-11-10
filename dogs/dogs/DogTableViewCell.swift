//
//  DogTableViewCell.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 04/11/2022.
//

import UIKit

class DogTableViewCell: UITableViewCell {
    
    let dogImageView: UIImageView
    let dogTitleLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.dogImageView = UIImageView()
        self.dogTitleLabel = UILabel()
        
        dogImageView.contentMode = .scaleAspectFit
        dogImageView.translatesAutoresizingMaskIntoConstraints = false
        dogTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        contentView.addSubview(dogImageView)
        contentView.addSubview(dogTitleLabel)
        
        NSLayoutConstraint.activate([
            dogImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            dogImageView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            dogImageView.widthAnchor.constraint(equalTo: dogImageView.heightAnchor),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: dogImageView.bottomAnchor, multiplier: 1),
            
            dogTitleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: dogImageView.trailingAnchor, multiplier: 2),
            dogTitleLabel.topAnchor.constraint(equalTo: dogImageView.topAnchor),
            dogTitleLabel.bottomAnchor.constraint(equalTo: dogImageView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: dogTitleLabel.trailingAnchor, multiplier: 1)
        ])
    }
    
    override func prepareForReuse() {
        dogImageView.image = nil
        dogTitleLabel.text = nil
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitle(with dogName: String, subbreed: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if let subbreed {
                self.dogTitleLabel.text = "\(subbreed) \(dogName)"
            } else {
                self.dogTitleLabel.text = dogName
            }
        }
    }
    
    func configureImage(with breed: String, subbreed: String? = nil) {
        
        DataProvider.shared.getRandomImageFor(breed, subbreed: subbreed) { imageData in
            guard
                let imageData,
                let image = UIImage(data: imageData)
            else {
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                guard let self else { return }
                self.dogImageView.image = image
            }
        }
    }
    
}
