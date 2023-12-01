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
    let emailValidateButton = PointButton(title: "중복확인", setbackgroundColor: .white)
    let emailValidateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    
    let signUpButton = PointButton(title: "회원가입", setbackgroundColor: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
    }
    
    func bind() {
        let input = SignUpViewModel.Input(email: emailTextField.rx.text.orEmpty, password: passwordTextField.rx.text.orEmpty,nickname: nicknameTextField.rx.text.orEmpty, emailValidateButtonClicked: emailValidateButton.rx.tap, signUpButtonClicked: signUpButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.emailValidateButtonEnabled
            .bind(to: emailValidateButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.emailValidateButtonEnabled
            .subscribe(with: self) { owner, bool in
                let color: UIColor = bool ? .black : .lightGray
                owner.emailValidateButton.layer.borderColor = color.cgColor
                owner.emailValidateButton.setTitleColor(color, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.emailValidateResponse
            .subscribe(with: self) { owner, response in
                print(response)
                owner.emailValidateLabel.text = response.message
                owner.emailValidateLabel.textColor = .black
            }
            .disposed(by: disposeBag)
        
        output.emailErrorMessage
            .subscribe(with: self) { owner, errorMessage in
                print(errorMessage)
                owner.emailValidateLabel.text = errorMessage
                owner.emailValidateLabel.textColor = .red
            }
            .disposed(by: disposeBag)
        
        output.signUpResponse
            .debug()
            .subscribe(with: self) { owner, response in
                print(response)
//                owner.navigationController?.pushViewController(LogInViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.signUpErrorMessage
            .subscribe(with: self) { owner, errorMessage in
                print(errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        [emailTextField, emailValidateButton, emailValidateLabel].forEach {
            emailContainerView.addSubview($0)
        }
        
        [emailContainerView, passwordTextField, nicknameTextField, signUpButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        emailContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(70)
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
        
        emailValidateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.height.equalTo(20)
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
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
}
