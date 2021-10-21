//
//  AuthorAndDateCell.swift
//  Messenger
//
//  Created by Крылов Данила  on 16.09.2021.
//

import UIKit
import Kingfisher

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
        setupDate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


// MARK: - Private methods

    private func setupImage() {

        addSubview(authorImage)
        NSLayoutConstraint.activate([
            authorImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            authorImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            authorImage.heightAnchor.constraint(equalToConstant: 35),
            authorImage.widthAnchor.constraint(equalTo: authorImage.heightAnchor, multiplier: 1/1)
        ])

        authorImage.layer.cornerRadius = 20
        authorImage.clipsToBounds = true
    }

    private func setupAuthorName() {

        addSubview(authorName)
        NSLayoutConstraint.activate([
            authorName.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            authorName.leadingAnchor.constraint(equalTo: authorImage.trailingAnchor, constant: 4),
            authorName.heightAnchor.constraint(equalToConstant: 20),
            authorName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4)
        ])

        authorName.adjustsFontSizeToFitWidth = true
    }

    private func setupDate() {

        addSubview(date)
        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: authorName.bottomAnchor, constant: 6),
            date.leadingAnchor.constraint(equalTo: authorImage.trailingAnchor, constant: 4),
            date.heightAnchor.constraint(equalToConstant: 14),
            date.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4)
        ])

        date.textColor = .gray

    }

// MARK: - Public methods
    
    func configure(post: Posts) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        date.text = dateFormatter.string(from: post.date)
    }

    func configure(authorIsUser: UsersNews) {
        authorImage.kf.setImage(with: URL(string: authorIsUser.photo))
        authorName.text = authorIsUser.firstName + " " + authorIsUser.lastName
    }

    func configure(authorIsGroup: GroupsNews) {
        authorImage.kf.setImage(with: URL(string: authorIsGroup.photo))
        authorName.text = authorIsGroup.name
    }
}
