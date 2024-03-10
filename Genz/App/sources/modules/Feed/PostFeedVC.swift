//
//  HomeFeedVC.swift
//  Genz
//
//  Created by Vivek MV on 09/03/24.
//

import UIKit
import EasyPeasy

class PostFeedVC: BaseFeedVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        fetchPosts()
    }
    
    override func setupNavbar() {
        navigationController?.navigationBar.backgroundColor = .backgroundPrimry
        navigationController?.navigationBar.barTintColor = .backgroundPrimry
        navigationItem.title = "Genz"
        
        // Create an image view with your image
        let profileButton = UIButton()
        profileButton.setImage(UIImage.profileImage, for: .normal)
        profileButton.contentMode = .scaleAspectFit
        profileButton.tintColor = .black
        profileButton.easy.layout(Size(30))
        profileButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: profileButton)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    override func refreshData(_ sender: Any) {
        posts.removeAll()
        fetchPosts()
    }
    
   @objc func didTapProfile() {
       let profileDetailVC = ProfileDetailVC()
       navigationController?.pushViewController(profileDetailVC, animated: true)
    }
}
