//
//  ProfileDetailVC.swift
//  Genz
//
//  Created by Vivek MV on 10/03/24.
//

import UIKit
import EasyPeasy

class ProfileDetailVC: BaseFeedVC {
    var profileData: ProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        fetchProfileDetails()
    }
    
    override func setupNavbar() {
        navigationController?.navigationBar.backgroundColor = .backgroundPrimry
        navigationController?.navigationBar.barTintColor = .backgroundPrimry
        navigationItem.title = "Profile"
        
        let backButton = BackButton()
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
    }
        
    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override func makeDataSource() -> BaseFeedVC.DataSource {
       let datasource =  super.makeDataSource()
        
        datasource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            
          guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
          }
            
          let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileDetailHeader.reuseIdentifier,
            for: indexPath) as? ProfileDetailHeader
          let _ = self?.dataSource.snapshot()
            .sectionIdentifiers[indexPath.section]
            view?.configure(profileData: self?.profileData)
          return view
        }
        return datasource
    }
    
    func fetchProfileDetails() {
        NetworkManager.shared.fetchData(from: GenxAPI.userDetail.path) { [weak self] (result: Result<ProfileDetail, Error>) in
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
            switch result {
                case .success(let postDetail):
                    self?.posts.append(contentsOf: postDetail.data.posts)
                    self?.profileData = postDetail.data
                    DispatchQueue.main.async {
                        self?.applySnapshot(animatingDifferences: false)
                    }
                case .failure(let error):
                    print(error)
                    self?.view.makeToast("Something went wrong. Please try refreshing the page.", position: .center)
            }
        }
    }
    
    override func refreshData(_ sender: Any) {
        refreshControl.endRefreshing()
    }
}


// MARK: -  DELEGATES


extension ProfileDetailVC {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}
