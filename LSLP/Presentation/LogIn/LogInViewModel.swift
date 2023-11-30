//
//  LogInViewModel.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/26.
//

import Foundation
import RxSwift
import RxCocoa

class LogInViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let loginButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let logInButtonEnabled: BehaviorRelay<Bool>
        let logInResponse: PublishRelay<LogInResponse>
        let errorMessage: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let loginInput = Observable.combineLatest(input.email, input.password)
        
        let logInButtonEnabled = BehaviorRelay(value: false)
        
        let logInResponse = PublishRelay<LogInResponse>()
        let errorMessage = PublishRelay<String>()
      
        
        loginInput
            .map {
                $0.0.isValidEmail() && $0.1.count > 4
            }
            .bind { bool in
                logInButtonEnabled.accept(bool)
            }
            .disposed(by: disposeBag)
        
        input.loginButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginInput)
            .flatMap { email, password in
                return APIManager.shared.loginRequest(api: .signIn(model: LoginIn(email: email, password: password)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case.success(let response):
                    print(response)
                    logInResponse.accept(response)
                    
                case .failure(let error):
                    print(error)
                    guard let logInError = LogInError(rawValue: error.rawValue) else {
                        errorMessage.accept(error.errorDescription)
                        return
                    }
                    errorMessage.accept(logInError.errorDescription)
                }
            }
            .disposed(by: disposeBag)
//            .subscribe(with: self) { owner, result in
//                switch result {
//                case.success(let data):
//                    signInResponse.
//                }
//            }
        
        return Output(logInButtonEnabled: logInButtonEnabled, logInResponse: logInResponse, errorMessage: errorMessage)
    }
    
}
