//
//  BackButton.swift
//  Genz
//
//  Created by Vivek MV on 10/03/24.
//

import UIKit
import EasyPeasy

class BackButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage.backButton, for: .normal)
        self.contentMode = .scaleAspectFit
        self.tintColor = .black
        self.easy.layout(Size(30))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
