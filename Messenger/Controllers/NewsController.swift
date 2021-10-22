//
//  NewsController.swift
//  Messenger
//
//  Created by Крылов Данила  on 16.09.2021.
//

import UIKit

//MARK: - CellType enum

enum CellType: Int, CaseIterable {
    case author = 0
    case text
    case photo
    case likes
}

final class NewsController: UIViewController {

// MARK: - Public property

    weak var network: NetworkLayerProtocol?

// MARK: - Private property

    private let refreshControl = UIRefreshControl()

    private let tableView = UITableView()

    private var posts = [Posts]()

    private var groupsAuthors = [GroupsNews]()

    private var usersAuthors = [UsersNews]()

    private var isLoading = false

    private var nextFrom = ""

// MARK: - Life cycle

    init(network: NetworkLayer?) {
        self.network = network
        super.init(nibName: nil, bundle: nil)
        getFeed()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Мои новости"
        
        setupTableView()
        setupRefreshController()

    }

// MARK: - Private methods

    private func setupTableView() {

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.backgroundColor = .systemGray
        
        tableView.register(AuthorAndDateCell.self, forCellReuseIdentifier: "AuthorDateCell")
        tableView.register(NewsContentCell.self, forCellReuseIdentifier: "NewsContentCell")
        tableView.register(NewsPhotoCell.self, forCellReuseIdentifier: "NewsPhotoCell")
        tableView.register(NewsLikesCommentsCell.self, forCellReuseIdentifier: "NewsLikesCommentsCell")

    }

    private func getFeed() {
        network?.getFeed(completion: { [weak self] feed in

            guard let self = self else { return }

            self.posts = feed.posts
            self.groupsAuthors = feed.groups
            self.usersAuthors = feed.users
            self.nextFrom = feed.startFrom

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        })
    }

    private func setupRefreshController() {

        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }

    @objc func refreshNews() {

        self.refreshControl.beginRefreshing()
        let mostFreshPost = self.posts.first?.date.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        FeedAPI.shared.get(startTime: mostFreshPost + 1) { [weak self] feed in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            let posts = feed.posts
            guard posts.count > 0 else { return }
            self.posts = posts + self.posts
            self.groupsAuthors = feed.groups + self.groupsAuthors
            self.usersAuthors = feed.users + self.usersAuthors

            let indexSet = IndexSet(integersIn: 0..<posts.count)
            self.tableView.insertSections(indexSet, with: .automatic)
        }
    }

    private func isGroupSource(post: Posts) -> Bool {

        if post.sourceId < 0 {
            return true
        }
        return false
    }

}



// MARK: - UITableViewDataSource

extension NewsController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CellType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = posts[indexPath.section]
        let cellType = CellType(rawValue: indexPath.row)

        switch cellType {

        case .author:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorDateCell",
                                                       for: indexPath) as?
                AuthorAndDateCell else { return UITableViewCell() }

            cell.configure(post: post)

            if isGroupSource(post: post) {
                let groupSourceId = -(post.sourceId)
                let neededGroups = groupsAuthors.filter { $0.id == groupSourceId }
                guard let group = neededGroups.first else { return UITableViewCell() }
                cell.configure(authorIsGroup: group)
            }

            if !isGroupSource(post: post) {
                let userSourceId = post.sourceId
                let neededUser = usersAuthors.filter { $0.id == userSourceId }
                guard let user = neededUser.first else { return UITableViewCell() }
                cell.configure(authorIsUser: user)
            }


        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell

        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsContentCell", for: indexPath) as?
                    NewsContentCell else { return UITableViewCell() }

            cell.configure(post: post)
//            print(cell.newsText.text)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell

        case .photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell", for: indexPath) as?
                    NewsPhotoCell else { return UITableViewCell() }

            cell.configure(post: post)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell

        case .likes:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesCommentsCell", for: indexPath) as?
                        NewsLikesCommentsCell else { return UITableViewCell() }

            cell.configure(post: post)
            cell.selectionStyle = .none
            cell.delegate = self
            cell.post = post
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            
            return cell

        default:
            return UITableViewCell()
        }
    }

}

// MARK: - UITableViewDelegate

extension NewsController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = CellType(rawValue: indexPath.row)
        let post = posts[indexPath.section]
        let tableViewWidth =  tableView.bounds.width

        ///calculate current photo height
        func calculatePhotoHeight(post: Posts) -> CGFloat {
            guard let height = post.photoHeight,
                  let width = post.photoWidth else { return UITableView.automaticDimension }

            let aspectRatio = CGFloat(height)/CGFloat(width)
            let cellHeight = tableViewWidth * aspectRatio
            return cellHeight

        }

        ///calcualte text's height
        func calculateHeight(of text: String) -> CGFloat {

            let approxWidthOfText = tableViewWidth - 8
            let size = CGSize(width: approxWidthOfText, height: .greatestFiniteMagnitude)
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let cellHeight = estimatedFrame.height
            return cellHeight + 20
        }



        switch cellType {
        case .author:
            return 70

        case .text:
            return calculateHeight(of: post.text ?? "")


        case .photo:
            if post.photo == nil {
                return 0
            }
            return calculatePhotoHeight(post: post)

        case .likes:
            return 50

        default:
            return 0
        }

    }

}

//MARK: LikesCommentsDelegate

extension NewsController: LikesCommentsDelegate {

    func likeAndCommentCell(_ newsLikesCommentsCell: NewsLikesCommentsCell, buttonTappedFor post: Posts) {

        let likedImage = UIImage(systemName: "heart.fill")
        let unlikedImage = UIImage(systemName: "heart")

        guard let likes = Int(newsLikesCommentsCell.likeCounterLabel.text ?? "") else { return }

        if !newsLikesCommentsCell.isLiked {
            newsLikesCommentsCell.likeButton.setImage(likedImage, for: .normal)
            let currentLikes = likes + 1
            newsLikesCommentsCell.likeCounterLabel.text = String(currentLikes)
            newsLikesCommentsCell.isLiked = true
        }
        else {
            newsLikesCommentsCell.likeButton.setImage(unlikedImage, for: .normal)
            let currentLikes = likes - 1
            newsLikesCommentsCell.likeCounterLabel.text = String(currentLikes)
            newsLikesCommentsCell.isLiked = false
        }
    }

//        guard let text = likeLabel.text else { return }
//
//        guard let numberOfLikes = Int(text) else { return }
//
//        var isLiked = false
//
//        if isLiked == false {
//            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//            let currentLikes = numberOfLikes + 1
//            likeLabel.text = String(currentLikes)
//            isLiked = true
//
//        } else {
//
//            button.setImage(UIImage(systemName: "heart"), for: .normal)
//            let currentLikes = numberOfLikes - 1
//            likeLabel.text = String(currentLikes)
//            isLiked = true
//        }




}

//MARK: - UITableViewDataSourcePrefetching

extension NewsController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }

        if maxSection > posts.count - 5,
           !isLoading {

            isLoading = true
            FeedAPI.shared.get(startFrom: nextFrom) { [weak self] feed in
                guard let self = self else { return }

                let posts = feed.posts
                let users = feed.users
                let groups = feed.groups

                let indexSet = IndexSet(integersIn: self.posts.count..<self.posts.count + posts.count)

                self.posts.append(contentsOf: posts)
                self.usersAuthors.append(contentsOf: users)
                self.groupsAuthors.append(contentsOf: groups)
                
                self.tableView.insertSections(indexSet, with: .automatic)
                self.nextFrom = feed.startFrom
                self.isLoading = false
            }
        }
    }


}

