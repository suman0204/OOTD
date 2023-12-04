//
//  APIManager.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/26.
//

import Foundation
import Moya
import RxSwift

enum CustomResult<T, E> {
    case success(T)
    case failure(E)
}

final class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    let provider = MoyaProvider<API>()
    
    func loginRequest(api: API) -> Single<CustomResult<LogInResponse, LoggableError>>{
        return Single.create { single in
            self.provider.request(api) { result in
                switch result {
                case.success(let value):
                    print("Success", value.statusCode, value.data)
                    
                    guard let data = try? JSONDecoder().decode(LogInResponse.self, from: value.data) else {
                        return
                    }
                    single(.success(.success(data)))
                    
                case .failure(let error):
                    print("Failure", error)
                    
                    guard let statusCode = error.response?.statusCode, let commonError = CommonError(rawValue: statusCode) else {
                        single(.success(.failure(CommonError.unknownError)))
                        return
                    }
                    
                    single(.success(.failure(commonError)))
                   
                }
            }
            return Disposables.create()
        }
    }
    
    func emailValidateRequest(api: API) -> Single<CustomResult<EmailValidationResponse, LoggableError>> {
        return Single.create { single in
            self.provider.request(api) { result in
                switch result {
                case.success(let value):
                    print("Success", value.statusCode, value.data)
                    
//                    if value.statusCode == 200 {
                        guard let data = try? JSONDecoder().decode(EmailValidationResponse.self, from: value.data) else {
                            return
                        }
                        single(.success(.success(data)))
//                    }
                    
                case.failure(let error):
                    print(error)
                    guard let statusCode = error.response?.statusCode, let commonError = CommonError(rawValue: statusCode) else {
                        single(.success(.failure(CommonError.unknownError)))
                        return
                    }
                    
                    single(.success(.failure(commonError)))
                }
            }
            return Disposables.create()
        }
    }
    
    func signUpRequest(api: API) -> Single<CustomResult<JoinResponse, LoggableError>> {
        return Single.create { single in
            self.provider.request(api) { result in
                switch result {
                case.success(let value):
                    print("Request Success", value.statusCode, value.data)

                    guard let data = try? JSONDecoder().decode(JoinResponse.self, from: value.data) else {
                        return
                    }
                    single(.success(.success(data)))
                case.failure(let error):
                    
                    print("Request Error", error)

                    guard let statusCode = error.response?.statusCode, let commonError = CommonError(rawValue: statusCode) else {
                        single(.success(.failure(CommonError.unknownError)))
                        return
                    }
                    
                    single(.success(.failure(commonError)))
                }
            }
            return Disposables.create()
        }
    }

    func postRequest(api: API) -> Single<CustomResult<PostResponse, LoggableError>> {
        return Single.create { single in
            self.provider.request(api) { result in
                switch result {
                case.success(let value):
                    print("Post Request Success", value.statusCode)
                    
                    guard let data = try? JSONDecoder().decode(PostResponse.self, from: value.data) else {
                        return
                    }
                    
                    single(.success(.success(data)))
                    
                case.failure(let error):
                    print("Post Request Error", error)
                    
                    guard let statusCode = error.response?.statusCode, let commonError = CommonError(rawValue: statusCode) else {
                        single(.success(.failure(CommonError.unknownError)))
                        return
                    }
                    
                    single(.success(.failure(commonError)))
                }
            }
            return Disposables.create()
        }
    }
}
