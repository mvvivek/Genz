//
//  ProfileDetailHeader.swift
//  Genz
//
//  Created by Vivek MV on 10/03/24.
//

import UIKit
import EasyPeasy

class ProfileDetailHeader: UICollectionReusableView {
    
  static var reuseIdentifier: String {
    return String(describing: ProfileDetailHeader.self)
  }

  lazy var titleLabel: UILabel = {
    let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    label.adjustsFontForContentSizeCategory = true
    label.textColor = .black
    label.textAlignment = .center
    label.numberOfLines = 1
    label.setContentCompressionResistancePriority(
      .defaultHigh,
      for: .horizontal)
    return label
  }()
    
    var profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 80 / 2
        return image
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundSecdry
        
        addSubview(profileImage)
        profileImage.easy.layout(Top(10), CenterX(), Size(80))
        
        addSubview(titleLabel)
        titleLabel.easy.layout(Top(10).to(profileImage), CenterX())
    }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    func configure(profileData: ProfileData?) {
        titleLabel.text = profileData?.username
        
        guard let profileURLString = profileData?.avatar,
              let imageURL = URL(string: profileURLString) else { return }
        profileImage.sd_setImage(with: imageURL,
                                 placeholderImage: UIImage.placeholderImage)
    }
}

