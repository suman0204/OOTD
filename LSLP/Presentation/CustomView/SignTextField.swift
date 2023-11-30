//
//  SignTextFiled.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/26.
//

import UIKit

class SignTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        
        textColor = .black
        placeholder = placeholderText
        textAlignment = .center
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
