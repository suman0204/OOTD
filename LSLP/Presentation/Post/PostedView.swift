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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
