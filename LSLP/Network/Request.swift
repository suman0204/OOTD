//
//  Request.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/23.
//

import Foundation

struct Join: Encodable {
    let email: String
    let password: String
    let nick: String
}

struct EmailValidation: Encodable {
    let email: String
}

struct LoginIn: Encodable {
    let email: String
    let password: String
}

struct Post: Encodable {
    let content: String
    let file: Data
    let product_id: String 
}
