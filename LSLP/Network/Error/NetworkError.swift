//
//  NetworkError.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/26.
//

import Foundation

enum CommonError: Int, LoggableError {
    case requiredValue = 400
    case noUserWrongPassword = 401
    case forbiden = 403
    case existing = 409
    case serverKey = 420
    case overCall = 429
    case urlError = 444
    case serverError = 500
    case unknownError = -1

    var errorDescription: String {
        switch self {
        case .serverKey:
            return "This service sesac_memolease only"
        case .overCall:
            return "과호출입니다."
        case .urlError:
            return "돌아가 여긴 자네가 올 곳이 아니야."
        case .serverError:
            return "ServerError"
        case .unknownError:
            return "알 수 없는 에러"
        default:
            return ""
        }
    }
}

enum SingUpError: Int, LoggableError {
    case requiredValue = 400
    case existing = 409
    
    var errorDescription: String {
        switch self {
        case .requiredValue:
            return "필수값을 채워주세요. (이메일, 비밀번호, 닉네임)"
        case .existing:
            return "이미 가입된 유저입니다."
        }
    }
}

enum EmailValidationError: Int, LoggableError {
    case requiredValue = 400
    case existing = 409
    
    var errorDescription: String {
        switch self {
        case .requiredValue:
            return "필수값을 채워주세요. (이메일)"
        case .existing:
            return "사용이 불가한 이메일입니다."
        }
    }
}

enum LogInError: Int, LoggableError {
    case requiredValue = 400
    case noUserWrongPassword = 401
    
    var errorDescription: String {
        switch self {
        case .requiredValue:
            return "필수값을 채워주세요. (이메일, 비밀번호)"
        case .noUserWrongPassword:
            return "계정을 확인해주시요 (미가입 or 비밀번호 불일치)"
        }
    }
}
