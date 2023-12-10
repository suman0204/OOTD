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
    case expiredRefreshToken = 418
    case expiredAccessToken = 419
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
            return "계정을 확인해주세요 (미가입 or 비밀번호 불일치)"
        }
    }
}

enum PostError: Int, LoggableError {
    case wrongRequset = 400
    case wrongToken = 401
    case forbidden = 403
    case notExisting = 410
    case expiredToken = 419
    
    var errorDescription: String {
        switch self {
        case .wrongRequset:
            "잘못된 요청입니다. (파일이 제한 사항과 맞지 않습니다.)"
        case .wrongToken:
            "인증할 수 없는 액세스 토큰입니다.(유효하지 않은 엑세스 토큰)"
        case .forbidden:
            "Forbidden (접근권한이 없습니다.)"
        case .notExisting:
            "생성된 게시글이 없습니다. (서버 장애로 게시글이 저장되지 않았습니다.)"
        case .expiredToken:
            "액세스 토큰이 만료되었습니다."
        }
    }
}

enum GetPostError: Int, LoggableError {
    case wrongRequest = 400
    case wrongToken = 401
    case forbidden = 410
    case expiredToken = 419
    
    var errorDescription: String {
        switch self {
        case .wrongRequest:
            "잘못된 요청입니다."
        case .wrongToken:
            "인증할 수 없는 액세스 토큰입니다. (유효하지 않은 액세스 토큰)"
        case .forbidden:
            "Forbidden (접근권한이 없습니다.)"
        case .expiredToken:
            "액세스 토큰이 만료되었습니다."
        }
    }
}

enum RefreshError: Int, LoggableError {
    case wrongToken = 401
    case forbidden = 403
    case notExpiredToken = 409
    case expiredRefreshToken = 418
    
    var errorDescription: String {
        switch self {
        case .wrongToken:
            "인증할 수 없는 액세스 토큰입니다. (유효하지 않은 액세스 토큰)"
        case .forbidden:
            "Forbidden (접근권한이 없습니다.)"
        case .notExpiredToken:
            "엑세스 토큰이 만료되지 않았습니다."
        case .expiredRefreshToken:
            "리프레시 토큰이 만료되었습니다. 다시 로그인 해주세요."
        }
    }
}
