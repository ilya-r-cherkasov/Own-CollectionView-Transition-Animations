//
//  CollectionViewCell.swift
//  CollectionView Custom Animation
//
//  Created by Ilya Cherkasov on 07.04.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let id = "CollectionViewCell"
    var image = Image(image: UIImage(named: "default")!) {
        willSet {
            imageView.image = newValue.cropImage()
        }
    }
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(#function)
    }
}
