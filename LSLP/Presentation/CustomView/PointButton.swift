//
//  PointButton.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/26.
//

import UIKit

class PointButton: UIButton {
    
    init(title: String, setbackgroundColor: UIColor) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = setbackgroundColor
        layer.cornerRadius = 10
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
