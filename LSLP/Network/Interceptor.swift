//
//  Interceptor.swift
//  LSLP
//
//  Created by 홍수만 on 2023/12/07.
//

import UIKit
import Alamofire
import RxSwift

final class Interceptor: RequestInterceptor {
    
    let disposeBag = DisposeBag()
    
    static let shared = Interceptor()
    
    private init() { }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("Enter Adapt")
        
        let path = urlRequest.url?.path(percentEncoded: true)
        print(path)
        
//        dump(urlRequest)
        
        guard urlRequest.url?.absoluteString.hasPrefix(APIKey.testURL) == true,
              ["/join", "/login","/validation"].contains(path) == false
        else {
            completion(.success(urlRequest))
            return
        }
        
        guard let accessToken = KeychainManager.shared.read(account: "token"), let refreshToken = KeychainManager.shared.read(account: "refreshToken") else {
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        
        print("/refresh")
        if ["/refresh"].contains(path) {
            urlRequest.setValue(refreshToken, forHTTPHeaderField: "Refresh")
        }
        
        print("adapt header", urlRequest.headers)
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("Start Retry", error)
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
        

            
            DispatchQueue.main.async {
                
                APIManager.shared.refresh(api: .refresh)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let response):
                            KeychainManager.shared.create(account: "token", value: response.token)
                            completion(.retry)
                        case .failure(let error):
                            completion(.doNotRetryWithError(error))
                        }
                    }
                    .disposed(by: self.disposeBag)
            }
        
        
    }
}
