//
//  FeedModel.swift
//  Genz
//
//  Created by Vivek MV on 08/03/24.
//

import Foundation

struct Post: Codable, Hashable {
    let postId: String
    let videoUrl: String
    let thumbnailUrl: String
    let profilePictureUrl: String
    let username: String
    let likes: Int
    
    static func == (lhs: Post, rhs: Post) -> Bool {
      lhs.postId == rhs.postId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(postId)
    }
}

struct Posts: Codable {
    let status: String
    let data: [Post]
}

struct ProfileDetail: Codable {
    let status: String
    let data: ProfileData
}

struct ProfileData: Codable {
    let username: String
    let avatar: String
    let posts: [Post]
}
