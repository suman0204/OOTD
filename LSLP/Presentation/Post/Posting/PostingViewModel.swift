//
//  PostingViewModel.swift
//  LSLP
//
//  Created by 홍수만 on 2023/12/04.
//

import Foundation
import RxSwift
import RxCocoa

class PostingViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    let imageData: PublishSubject<[Data]> = PublishSubject()
    
    struct Input {
        let content: ControlProperty<String>
        let postingButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let postResponse: PublishRelay<PostResponse>
        let errorMessage: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let postResponse = PublishRelay<PostResponse>()
        let errorMessage = PublishRelay<String>()

        let postData = Observable.combineLatest(input.content, imageData)
        
        input.postingButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(postData)
            .flatMap { data in
                APIManager.shared.postRequest(api: .post(model: Post(content: data.0, file: data.1.first ?? Data(), product_id: "test0204")))
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print(result)
                    postResponse.accept(result)
                case .failure(let error):
                    print(error)
                    print(error.rawValue)
                    guard let postError = PostError(rawValue: error.rawValue) else {
                        errorMessage.accept(error.errorDescription)
                        return
                    }
                    errorMessage.accept(postError.errorDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(postResponse: postResponse, errorMessage: errorMessage)
    }
}
