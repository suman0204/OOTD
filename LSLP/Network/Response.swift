//
//  Response.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/23.
//

import Foundation

struct JoinResponse: Decodable {
    let _id: String
    let email: String
    let nick: String
}

struct EmailValidationResponse: Decodable {
    let message: String
}

struct LogInResponse: Decodable {
    let token: String
    let refreshToken: String
}

struct RefreshResponse: Decodable {
    let token: String
}

struct WithdrawResponse: Decodable {
    let _id: String
    let email: String
    let nick: String
}

struct PostResponse: Decodable {
    let likes, image, hashTags: [String?]
    let _id, time, content, product_id: String
    let creator: Creator
    let comments: [Comments]
}

struct Creator: Decodable {
    let _id: String
    let nick: String
    let profile: String?
}

struct Comments: Decodable {
    let _id: String
    let content: String
    let time: String
    let creator: Creator
}

struct GetPostResponse: Decodable {
    let data: [PostResponse]
    let next_cursor: String
}
