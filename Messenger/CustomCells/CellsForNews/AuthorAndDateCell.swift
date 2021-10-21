//
//  AuthorAndDateCell.swift
//  Messenger
//
//  Created by Крылов Данила  on 16.09.2021.
//

import UIKit

final class AuthorAndDateCell: UITableViewCell {

// MARK: - Private property

    private let authorImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "heart.fill")
        return image
    }()

    private let authorName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some text"
        return label
    }()

    private let date: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some text"
        return label
    }()

// MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImage()
        setupAuthorName()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }







// MARK: - Private methods

    private func setupImage() {

        addSubview(authorImage)
        NSLayoutConstraint.activate([
            authorImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            authorImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            authorImage.heightAnchor.constraint(equalToConstant: 20),
            authorImage.widthAnchor.constraint(equalTo: authorImage.heightAnchor, multiplier: 1/1)
        ])

        authorImage.layer.cornerRadius = 10
        authorImage.clipsToBounds = true
    }

    private func setupAuthorName() {

        addSubview(authorName)
        NSLayoutConstraint.activate([
            authorName.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            authorName.leadingAnchor.constraint(equalTo: authorName.trailingAnchor, constant: 4),
        ])
    }
}
