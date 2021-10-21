//
//  UniversalCell.swift
//  Messenger
//
//  Created by Крылов Данила  on 20.08.2021.
//

import UIKit
import Kingfisher

class UniversalCell: UITableViewCell {

// MARK: - Private Property

    private let image = UIImageView()
    private let nameLabel = UILabel ()

//MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(image)
        addSubview(nameLabel)

        setImageConstraints()
        setLabelConstraints()
        configureImageView()
        configureNameLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Private methods

    private func configureImageView() {
        image.layer.cornerRadius = 35
        image.clipsToBounds = true
    }

    private func configureNameLabel() {
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.numberOfLines = 0
    }

    private func setImageConstraints() {

        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        image.heightAnchor.constraint(equalToConstant: 70).isActive = true
        image.widthAnchor.constraint(equalTo: image.heightAnchor, multiplier: 1/1).isActive = true
    }

    private func setLabelConstraints() {

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 55).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12).isActive = true

    }

//MARK: - Public methods

    func configure(user: Users) {
        image.kf.setImage(with: URL(string: user.avatar))
        nameLabel.text = user.firstName  + " " + user.lastName
    }

    func configure(groups: Groups) {
        image.kf.setImage(with: URL(string: groups.groupAvatar))
        nameLabel.text = groups.name
    }

}
