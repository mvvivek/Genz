//
//  UserInfoView.swift
//  Genz
//
//  Created by Vivek MV on 10/03/24.
//

import UIKit
import EasyPeasy

class UserInfoView: UIView {
        
    var postId: String?
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()

    var profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 42 / 2
        return image
    }()
    
    var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    var nlikes: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImage)
        profileImage.easy.layout(Top(10), Left(14), Size(42))
        
        addSubview(likeButton)
        likeButton.easy.layout(CenterY(), Right(14), Size(32))
        
        addSubview(name)
        name.easy.layout(Top().to(profileImage, .top), Left(5).to(profileImage), Right(5).to(likeButton))
                
        addSubview(nlikes)
        nlikes.easy.layout(Top(2).to(name), Left(5).to(profileImage), Right(5).to(likeButton))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLike() {
        guard let postId = postId else {
            return
        }
        let currentPostLikeStatus = !(Store.shared.likes[postId] ?? false)
        Store.shared.likes[postId] = !currentPostLikeStatus
        let isLiked = Store.shared.likes[postId] ?? false
        likeButton.setImage(UIImage(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup"), for: .normal)
    }
    
    func configure(post: Post?) {
        postId = post?.postId
        name.text = post?.username
        nlikes.text = String(post?.likes ?? 0) + " likes"
        let isLiked = Store.shared.likes[postId ?? ""] ?? false
        likeButton.setImage(UIImage(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup"),
                            for: .normal)
        
        if let profileImageURLString = post?.profilePictureUrl,
           let imageURL = URL(string: profileImageURLString) {
            profileImage.sd_setImage(with: imageURL,
                                  placeholderImage: UIImage(systemName: "person.crop.circle"))
        }
    }
}
