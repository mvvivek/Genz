//
//  PostDetailVC.swift
//  Genz
//
//  Created by Vivek MV on 09/03/24.
//

import UIKit
import EasyPeasy

class PostDetailVC: UIViewController {
    
   lazy var videoView: GenzVideoPlayer = {
       let view = GenzVideoPlayer(url: post.videoUrl)
       view.backgroundColor = .black
       view.layer.cornerRadius = 10
       view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       view.clipsToBounds = true
        return view
    }()
    
    let userInfoView: UserInfoView = {
        let view = UserInfoView()
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    let post: Post
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundPrimry
        
        navigationController?.navigationBar.backgroundColor = .backgroundPrimry
        navigationController?.navigationBar.barTintColor = .backgroundPrimry
        navigationItem.title = "Detail"
        
        let backButton = BackButton()
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
        
        setupPlayer()
    }
    
    func setupPlayer() {
        view.addSubview(videoView)
        videoView.easy.layout(Top(20).to(view.safeAreaLayoutGuide, .top),
                              Left(10),
                              Right(10),
                              Height(*0.6).like(view))
        
        view.addSubview(userInfoView)
        userInfoView.backgroundColor = .lightGray
        userInfoView.easy.layout(Top().to(videoView), Left(10), Right(10), Height(62))
        userInfoView.configure(post: post)
    }
    
    
    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}
