//
//  FriendsViewController.swift
//  Messenger
//
//  Created by Крылов Данила  on 20.08.2021.
//

import UIKit
import RealmSwift

final class FriendsViewController: UIViewController {

//MARK: - Public Property

    weak var network: NetworkLayerProtocol?

//MARK: - Private Property

    private let universalCell = "universalCell"

    private let tableView = UITableView()
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Найти друга"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private var friends: Results<Users>?
    private var token: NotificationToken?
    private var filteredFriends: [Users]!
    private var searchFlag = false


    init(network: NetworkLayerProtocol? = nil) {
        self.network = network
        super.init(nibName: nil, bundle: nil)
        setupFriendsList()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Мои друзья"
        view.backgroundColor = .systemGray
        setupSearchBar()
        setupTableView()
        loadAndNotificateTableView()
        self.filteredFriends = arrayForSearch()
    }

//MARK: - Private methods

    private func arrayForSearch() -> [Users] {
        guard let friends = self.friends else { return [] }
        return Array(friends)
    }

    private func setupSearchBar() {

        view.addSubview(searchBar)

        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])

        searchBar.delegate = self

    }

    private func setupTableView() {

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UniversalCell.self, forCellReuseIdentifier: universalCell)
        tableView.backgroundColor = .systemGray
    }

    private func loadAndNotificateTableView() {

        loadFriendsFromRealm()
        
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)

        do {
            let realm = try Realm(configuration: configuration)
            let friends = realm.objects(Users.self)
            self.token = friends.observe({ [ weak self ] changes in

                guard let self = self else { return }
                switch changes {
                case .initial:
                    self.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    self.tableView.endUpdates()
                case .error(let error):
                    print(error)
                }

            })
        } catch {
            print(error)
        }

    }

    private func loadFriendsFromRealm() {
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: configuration)
            let friends = realm.objects(Users.self)
            self.friends = friends
        } catch {
            print(error)
        }
    }

    private func setupFriendsList() {
        network?.fetchFriendsList()
    }

//    private func firstLetterSections(list: Results<Users>) -> ([Users],[Character]) {
//
//        var firstLetters = [Character]()
//        var sortedFriends = [Users]()
//
//        for user in list {
//            if let firstLetter = user.firstName.first {
//                if !firstLetters.contains(firstLetter) {
//                    firstLetters.append(firstLetter)
//                }
//            }
//            for letter in firstLetters {
//                let firstLetter = user.firstName.first
//                if letter == firstLetter {
//                    sortedFriends.append(user)
//                }
//            }
//        }
//
//        return (sortedFriends,firstLetters)
//    }


}

//MARK: - Extension SearchBarDelegate

extension FriendsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            filteredFriends = arrayForSearch()
        } else {
            searchFlag = true
            filteredFriends = filteredFriends.filter { ($0.firstName + " " + $0.lastName).lowercased()
                .contains(searchText.lowercased())}
        }

        self.tableView.reloadData()

    }
}

//MARK: - Extension: Delegate

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        let friends = filteredFriends[indexPath.row]
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
        if editingStyle == .delete {
            do {
                let realm = try Realm(configuration: configuration)
                realm.beginWrite()
                realm.delete(friends)
                try realm.commitWrite()

            } catch {
                print(error)
            }
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let friendsList = filteredFriends else { return }
        let friends = friendsList[indexPath.row]
        let friendsId = friends.id

        let network = NetworkLayer()
        let friendsPhotoController = FriendsPhotoController(network: network, friendsId: friendsId)
        navigationController?.pushViewController(friendsPhotoController, animated: true)

    }

}

//MARK: - Extension: DataSource

extension FriendsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard let friends = arrayForSearch() else { return Int() }
        return filteredFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: universalCell,
                                                       for: indexPath) as? UniversalCell else {
            return UITableViewCell()
        }
        //guard let friends = filteredFriends else { return UITableViewCell() }
        cell.configure(user: filteredFriends[indexPath.row])
        return cell
    }

}
