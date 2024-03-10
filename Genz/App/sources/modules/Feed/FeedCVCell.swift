//
//  VideoCVCell.swift
//  Genz
//
//  Created by Vivek MV on 09/03/24.
//

import UIKit
import EasyPeasy
import SDWebImage

class FeedCVCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
      return String(describing: FeedCVCell.self)
    }
    
    let userInfoView = UserInfoView()
    
    lazy var thumbnail: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return image
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.backgroundColor = .backgroundSecdry
        
        addSubview(thumbnail)
        thumbnail.easy.layout(Top(), Left(), Right(), Height(212))
            
        addSubview(userInfoView)
        userInfoView.easy.layout(Top().to(thumbnail), Left(), Right(), Bottom())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post?) {
        thumbnail.image = UIImage(named: "placeholderImage")
        userInfoView.configure(post: post)
        guard let thumbnailURLString = post?.thumbnailUrl,
              let imageURL = URL(string: thumbnailURLString) else { return }
        thumbnail.sd_setImage(with: imageURL,
                              placeholderImage: UIImage(named: "placeholderImage"))
    }
}

