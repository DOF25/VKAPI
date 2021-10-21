//
//  NewsContentCell.swift
//  Messenger
//
//  Created by Крылов Данила  on 17.09.2021.
//

import UIKit

final class NewsContentCell: UITableViewCell {

//MARK: - Public property

    public let newsText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
//        label.allowsEditingTextAttributes = false
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()

//MARK: - Private property
    private let showMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ещё", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption2)
        return button
    }()


// MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupNewsText()
        setupShowMoreButton()
        contentView.clipsToBounds = true

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


// MARK: - Private methods

    private func setupNewsText() {

        addSubview(newsText)
        NSLayoutConstraint.activate([
            newsText.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            newsText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            newsText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4)
        ])
    }

    private func setupShowMoreButton() {

        addSubview(showMoreButton)
        NSLayoutConstraint.activate([
            showMoreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            showMoreButton.heightAnchor.constraint(equalToConstant: 20),
            showMoreButton.topAnchor.constraint(equalTo: newsText.bottomAnchor, constant: 2)
        ])

    }

    func configure(post: Posts) {

        newsText.text = post.text

    }

}
