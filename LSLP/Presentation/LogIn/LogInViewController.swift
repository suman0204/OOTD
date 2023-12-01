//
//  LogIngViewController.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LogInViewController: BaseViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let logInButton = PointButton(title: "로그인", setbackgroundColor: .black)
    let signUpButton = {
        let button = UIButton()
        button.setTitle("회원이 아니십니까?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = LogInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
    }
    
   @objc func signUpButtonClicked() {
       self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    func bind() {
        let input = LogInViewModel.Input(email: emailTextField.rx.text.orEmpty, password: passwordTextField.rx.text.orEmpty, loginButtonClicked: logInButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.logInButtonEnabled
//            .debug()
            .bind(with: self, onNext: { owner, bool in
                owner.logInButton.rx.isEnabled.onNext(bool)
            })
            .disposed(by: disposeBag)
        
        output.logInButtonEnabled
            .bind(with: self) { owner, value in
                let buttonBackgrounColor: UIColor = value ? .black : .white
                let buttonTitleColor: UIColor = value ? .white : .black
                owner.logInButton.backgroundColor = buttonBackgrounColor
                owner.logInButton.layer.borderColor = buttonTitleColor.cgColor
                owner.logInButton.setTitleColor(buttonTitleColor, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.logInResponse
            .subscribe(with: self) { owner, response in
                print("Login Response", response)
                owner.navigationController?.pushViewController(PostedView(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .subscribe(with: self) { owner, error in
                print("Error Response", error)
                
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.backgroundColor = .white
        [emailTextField, passwordTextField, logInButton, signUpButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        logInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(logInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
