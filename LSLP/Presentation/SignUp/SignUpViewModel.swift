//
//  SingUpViewModel.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/28.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let nickname: ControlProperty<String>
        let emailValidateButtonClicked: ControlEvent<Void>
        let signUpButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let emailValidateButtonEnabled: BehaviorSubject<Bool>
        let emailValidateResponse: PublishRelay<EmailValidationResponse>
        let emailErrorMessage: PublishRelay<String>
        
        let signUpResponse: PublishRelay<JoinResponse>
        let signUpErrorMessage: PublishRelay<String>
        
//        let singUpButtonEnabled: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let emailValidateEnabled = BehaviorSubject(value: false)
        let emailValidateResponse = PublishRelay<EmailValidationResponse>()
        let emailErrorMessage = PublishRelay<String>()
        
        let signUpResponse = PublishRelay<JoinResponse>()
        let signUpErrorMessage = PublishRelay<String>()
        
        input.email
            .map {
                $0.isValidEmail()
            }
            .bind(to: emailValidateEnabled)
            .disposed(by: disposeBag)
        
        input.emailValidateButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.email) { void, email in
                return email
            }
            .flatMapLatest { email in
                APIManager.shared.emailValidateRequest(api: .emailValidation(model: EmailValidation(email: email)))
            }
            .subscribe(with: self) { owenr, result in
                switch result {
                case.success(let value):
                    emailValidateResponse.accept(value)
                case .failure(let error):
                    guard let emailValidationError = EmailValidationError(rawValue: error.rawValue) else {
                        emailErrorMessage.accept(error.errorDescription)
                        return
                    }
                    emailErrorMessage.accept(emailValidationError.errorDescription)
                }

            }
            .disposed(by: disposeBag)
//            .subscribe(with: self) { owner, value in
//                print(value)
//                switch value {
//                case.success(let response):
//                    print(response)
//                    emailValidateResponse.bind(onNext: response)
//                case.failure(let error):
//                    print(error.errorDescription)
//                }
//            }
//            .disposed(by: disposeBag)
        
        let signUpData = Observable.combineLatest(input.email, input.password, input.nickname)
//            .debug()
//

        input.signUpButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signUpData)
            .debug()
            .flatMapLatest { email, password, nickname in
                APIManager.shared.signUpRequest(api: .signUp(model: Join(email: email, password: password, nick: nickname)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case.success(let value):
                    print("SignUp Value", value)
                    signUpResponse.accept(value)
                case.failure(let error):
                    print("SignUp Error", error)
                    signUpErrorMessage.accept(error.errorDescription)
                }
            }
            .disposed(by: disposeBag)
        
//        let singUpButtonClicked = input.singUpButtonClicked
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(signUpData)
//            .flatMapLatest { signUpData in
//                APIManager.shared.
//            }
        
        return Output(emailValidateButtonEnabled: emailValidateEnabled, emailValidateResponse: emailValidateResponse, emailErrorMessage: emailErrorMessage, signUpResponse: signUpResponse, signUpErrorMessage: signUpErrorMessage)
    }
}
