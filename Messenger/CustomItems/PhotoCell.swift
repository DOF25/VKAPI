//
//  PhotoCell.swift
//  Messenger
//
//  Created by Крылов Данила  on 10.09.2021.
//

import UIKit
import Kingfisher

final class PhotoCell: UICollectionViewCell {

// MARK: Private property

    private let friendsImage: UIImageView = {
        let friendsImage = UIImageView()
        friendsImage.translatesAutoresizingMaskIntoConstraints = false
        friendsImage.image = UIImage(systemName: "heart")
        return friendsImage
    }()

// MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Private methods

    private func setImage() {
        addSubview(friendsImage)

        NSLayoutConstraint.activate([
            friendsImage.topAnchor.constraint(equalTo: topAnchor),
            friendsImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            friendsImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            friendsImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

    }

//MARK: - Public methods

    func configure(photo: Photos) {
        friendsImage.kf.setImage(with: URL(string: photo.url))
    }

    


}
