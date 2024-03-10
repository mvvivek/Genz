//
//  FeedVC.swift
//  Genz
//
//  Created by Vivek MV on 10/03/24.
//

import UIKit
import EasyPeasy
import Toast

class BaseFeedVC: UIViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - PROPERTIES
    
    
    var posts: [Post] = []
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Post>
    lazy var dataSource = makeDataSource()
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Post>
    
    
    // MARK: - VIEWS
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionHeadersPinToVisibleBounds = false
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(
            ProfileDetailHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileDetailHeader.reuseIdentifier
        )
        cv.register(FeedCVCell.self, forCellWithReuseIdentifier: FeedCVCell.reuseIdentifier)
        cv.delegate = self
        cv.backgroundColor = .backgroundPrimry
        return cv
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupNavbar() {}
    
    func setupUI() {
        view.backgroundColor = .backgroundPrimry
        view.addSubview(collectionView)
        collectionView.easy.layout(Edges())
                
        collectionView.addSubview(activityIndicatorView)
        activityIndicatorView.easy.layout(Top(50).to(view.safeAreaLayoutGuide, .top), CenterX())
        activityIndicatorView.startAnimating()
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, video) ->
                UICollectionViewCell? in
                
                guard let posts = self?.posts, posts.count > 0 else {
                    return nil
                }
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FeedCVCell.reuseIdentifier,
                    for: indexPath) as? FeedCVCell
                cell?.configure(post: posts[indexPath.row])
                return cell
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func fetchPosts(completion: (() ->Void)? = nil) {
        NetworkManager.shared.fetchData(from: GenxAPI.posts.path) { [weak self] (result: Result<Posts, Error>) in
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
            switch result {
                case .success(let posts):
                    self?.posts.append(contentsOf: posts.data)
                    DispatchQueue.main.async {
                        self?.applySnapshot(animatingDifferences: false)
                        completion?()
                    }
                case .failure(let error):
                    print(error)
                    self?.view.makeToast("Something went wrong. Please try refreshing the page.", position: .center)
                    completion?()
            }
        }
    }
    
    @objc func refreshData(_ sender: Any) {}
}


// MARK: - COLLECTION VIEW DELEGATES


extension BaseFeedVC {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let postDetailVC = PostDetailVC(post: post)
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}


// MARK: - COLLECTION FLOW LAYOUT DELEGATES


extension BaseFeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 212 + 42 + 20 // Thumbnail height + ProfileImage height + spacing
        return CGSize(width: collectionView.frame.width - 20, height: height)
    }
}
