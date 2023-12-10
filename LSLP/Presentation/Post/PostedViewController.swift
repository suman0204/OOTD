//
//  PostedView.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PostedViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let titleLabel = {
        let view = UILabel()
        view.text = "메인"
        return view
    }()
    
    lazy var postingButton = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(postingButtonClicked))
        button.tintColor = .black
        
        return button
    }()
    
    lazy var refreshButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        return button
    }()
    
    @objc func refresh() {
        print("refresh click")
        APIManager.shared.refresh(api: .refresh)
            .subscribe(with: self) { owner, result in
                switch result {
                case.success(let response):
                    print(response)
                case.failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc func postingButtonClicked() {
        print("postingButtonClicked")
        self.navigationController?.pushViewController(PostingViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Token",KeychainManager.shared.read(account: "token"))
        print("RefreshToken",KeychainManager.shared.read(account: "refreshToken"))
        
        navigationItem.rightBarButtonItem = postingButton
    }
    
    override func configureView() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(refreshButton)

    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalTo(titleLabel.snp.bottom).offset(100)
        }
    }
}
