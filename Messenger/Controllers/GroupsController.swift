//
//  GroupsController.swift
//  Messenger
//
//  Created by Крылов Данила  on 22.08.2021.
//

import UIKit
import RealmSwift
import PromiseKit

final class GroupsController: UIViewController {

//MARK: - Private property

    private var groups: Results<Groups>?
    private var token: NotificationToken?

    private let tableView = UITableView()
    private let universalCell = "universalCell"


 //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Мои группы"
        setupTableView()
        setupGroupList()
        loadAndNotificateTableView()
    }

    

//MARK: - Private methods

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray
        tableView.frame = view.bounds
        tableView.register(UniversalCell.self, forCellReuseIdentifier: universalCell)
    }

    private func loadGroupsFromRealm() {
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: configuration)
            let groups = realm.objects(Groups.self)
            self.groups = groups
        } catch {
            print(error)
        }
    }

    private func setupGroupList() {

        NetworkLayerForPromise.shared.downloadJsonGroups(url: URLs.groupList)
            .map { groups in
                let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
                let realm = try? Realm(configuration: configuration)
                realm?.beginWrite()
                realm?.add(groups, update: .modified)
                try realm?.commitWrite()
            }.done { [weak self] in
                self?.tableView.reloadData()
            }.catch(policy: .allErrors) { error in
                print(error)
            }

    }


    private func loadAndNotificateTableView() {

        loadGroupsFromRealm()

        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)

        do {
            let realm = try Realm(configuration: configuration)
            let groups = realm.objects(Groups.self)
            self.token = groups.observe({ [ weak self ] changes in

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

}



//MARK: - Extension: UITableViewDelegate

extension GroupsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard let groups = groups?[indexPath.row] else { return }
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: configuration)
            realm.beginWrite()
            realm.delete(groups)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}

//MARK: - Extension: UITableViewDataSource

extension GroupsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let groups = groups else { return Int() }
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: universalCell,
                                                       for: indexPath) as? UniversalCell else {
            return UITableViewCell()}

        guard let groups = groups else { return UITableViewCell() }
        cell.configure(groups: groups[indexPath.row])
        return cell
    }



}
