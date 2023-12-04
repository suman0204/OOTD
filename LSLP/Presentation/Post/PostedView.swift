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

class PostedView: BaseViewController {
    
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
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
