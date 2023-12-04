//
//  PostingViewController.swift
//  LSLP
//
//  Created by 홍수만 on 2023/12/02.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import PhotosUI

class PostingViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = PostingViewModel()
    
    let imagePickerButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "plus")
        config.imagePlacement = .top
        config.imagePadding = 10
        config.title = "사진 추가하기"
        config.titleAlignment = .center
        config.baseForegroundColor = .black
        
        let button = UIButton(configuration: config)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        
        return button
    }()
    
    let contentTextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        
        return textView
    }()
    
    let postingButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        config.title = "등록하기"
        let button = UIButton(configuration: config)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        let input = PostingViewModel.Input(content: contentTextView.rx.text.orEmpty, postingButtonClicked: postingButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.postResponse
            .subscribe(with: self) { owner, response in
                print("Post Response", response)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .subscribe(with: self) { owner, errorMessage in
                print("Post Error", errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.backgroundColor = .white
        [imagePickerButton, contentTextView, postingButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        imagePickerButton.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.width.equalTo(100)
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(imagePickerButton.snp.bottom).offset(20)
            make.height.equalTo(150)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        postingButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
