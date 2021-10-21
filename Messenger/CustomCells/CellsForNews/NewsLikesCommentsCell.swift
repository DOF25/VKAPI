//
//  NewsLikesCommentsCell.swift
//  Messenger
//
//  Created by Крылов Данила  on 17.09.2021.
//

import UIKit

final class NewsLikesCommentsCell: UITableViewCell {

// MARK: - Private property

    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()

    let likeCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "Number of Likes"
        return label
    }()

    let commentsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "doc.append")
        return imageView
    }()

    let commentsCounter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "Number of Comments"
        return label
    }()


// MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLikeImage()
        setuplikeCounterLabel()
        setupCommentsImage()
        setupCommentsCounter()


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


// MARK: - Private methods

    private func setupLikeImage() {

        addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            likeButton.heightAnchor.constraint(equalToConstant: 20),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor, multiplier: 1/1)
        ])

        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)

    }

    @objc private func like() {
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }

    private func setuplikeCounterLabel() {

        addSubview(likeCounterLabel)

        NSLayoutConstraint.activate([
            likeCounterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            likeCounterLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 4),
        ])
    }

    private func setupCommentsImage() {

        addSubview(commentsImage)

        NSLayoutConstraint.activate([
            commentsImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            commentsImage.leadingAnchor.constraint(equalTo: likeCounterLabel.trailingAnchor, constant: 4),
            commentsImage.heightAnchor.constraint(equalToConstant: 20),
            commentsImage.widthAnchor.constraint(equalTo: commentsImage.heightAnchor, multiplier: 1/1)
        ])
    }

    private func setupCommentsCounter() {

        addSubview(commentsCounter)

        NSLayoutConstraint.activate([
            commentsCounter.centerYAnchor.constraint(equalTo: centerYAnchor),
            commentsCounter.leadingAnchor.constraint(equalTo: commentsImage.trailingAnchor, constant: 4)
        ])
    }

    func configure(post: Posts) {
        likeCounterLabel.text = String(post.likes)
        commentsCounter.text = String(post.comments)
    }
    
}
