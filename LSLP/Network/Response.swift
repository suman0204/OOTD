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
