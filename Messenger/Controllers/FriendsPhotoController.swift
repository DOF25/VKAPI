//
//  FriendsPhotoController.swift
//  Messenger
//
//  Created by Крылов Данила  on 10.09.2021.
//

import UIKit
import RealmSwift

final class FriendsPhotoController: UIViewController {

// MARK: - Public property

    weak var network: NetworkLayerProtocol?

// MARK: - Private property
    private var photos = [Photos]()
    private let friendsId: Int

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

// MARK: - Life cycle

    init(network: NetworkLayerProtocol?, friendsId: Int) {
        self.network = network
        self.friendsId = friendsId
        super.init(nibName: nil, bundle: nil)
        network?.fetchPhotos(usersID: friendsId)
        loadPhotosFromRealm()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionViewAndConstraints()
        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        showFriendsPhoto()
    }

    deinit {
        self.collectionView.reloadData()
    }

// MARK: - Private methods

    private func showFriendsPhoto() {

        DispatchQueue.main.async { [weak self] in

            guard let self = self else { return }
            self.loadPhotosFromRealm()
            self.collectionView.reloadData()
        }
    }

    private func setCollectionViewAndConstraints() {

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }

    private func loadPhotosFromRealm() {
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: configuration)
            let photos = realm.objects(Photos.self)
            self.photos = Array(photos)
            self.collectionView.reloadData()
        } catch {
            print(error)
        }
    }
}




// MARK: - CollectionView delegate

extension FriendsPhotoController: UICollectionViewDelegate {


}

extension FriendsPhotoController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (view.frame.width)/3 - 2, height: (view.frame.width)/3 - 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 3, left: 0.5, bottom: 3, right: 0.5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0

    }


}

// MARK: - CollectionView dataSource
extension FriendsPhotoController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return photos.count
    }


    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell",
                                                            for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()}

        cell.configure(photo: photos[indexPath.row])
        
        return cell
    }


}


