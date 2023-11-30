//
//  SignUpViewController.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController {
    
    let viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    let emailContainerView = UIView()
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let emailValidateButton = PointButton(title: "중복확인")
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    
    let singUpButton = PointButton(title: "회원가입")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
    }
    
    func bind() {
        let input = SignUpViewModel.Input(email: emailTextField.rx.text.orEmpty, password: emailTextField.rx.text.orEmpty, emailValidateButtonClicked: emailValidateButton.rx.tap, singUpButtonClicked: singUpButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.emailValidateButtonEnabled
            .bind(to: emailValidateButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.emailValidateResponse
            .subscribe(with: self) { owner, response in
                print(response)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .subscribe(with: self) { owner, errorMessage in
                print(errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        [emailTextField, emailValidateButton].forEach {
            emailContainerView.addSubview($0)
        }
        
        [emailContainerView, passwordTextField, nicknameTextField, singUpButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        emailContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
        }
        
        emailValidateButton.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField.snp.trailing).offset(10)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailContainerView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        singUpButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
}
