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
        let emailValidateButtonClicked: ControlEvent<Void>
        let singUpButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let emailValidateButtonEnabled: Observable<Bool>
        let emailValidateResponse: PublishRelay<EmailValidationResponse>
        let errorMessage: PublishRelay<String>
//        let singUpButtonEnabled: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let emailValidateEnabled = input.email
            .map {
                $0.isValidEmail()
            }
        
        let emailValidateResponse = PublishRelay<EmailValidationResponse>()
        let errorMessage = PublishRelay<String>()
        
        input.emailValidateButtonClicked
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
                        errorMessage.accept(error.errorDescription)
                        return
                    }
                    errorMessage.accept(emailValidationError.errorDescription)
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
        
//        let signUpData = Observable.combineLatest(input.email, input.password)
//        
//        let singUpButtonClicked = input.singUpButtonClicked
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(signUpData)
//            .flatMapLatest { signUpData in
//                APIManager.shared.
//            }
        
        return Output(emailValidateButtonEnabled: emailValidateEnabled, emailValidateResponse: emailValidateResponse, errorMessage: errorMessage)
    }
}
