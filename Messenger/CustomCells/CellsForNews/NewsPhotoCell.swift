//
//  NewsPhotoCell.swift
//  Messenger
//
//  Created by Крылов Данила  on 17.09.2021.
//

import UIKit
import Kingfisher

final class NewsPhotoCell: UITableViewCell {

// MARK: - Private property

    private let newsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

// MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupNewsImage()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Private methods


    private func setupNewsImage() {

        addSubview(newsImage)
        NSLayoutConstraint.activate([
            newsImage.topAnchor.constraint(equalTo: topAnchor),
            newsImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(post: Posts) {
        if let photo = post.photo {
        newsImage.kf.setImage(with: URL(string: photo))
        } else {
            newsImage.image = nil
        }

    }

}
