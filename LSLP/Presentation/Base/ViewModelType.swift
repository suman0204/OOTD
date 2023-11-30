//
//  ViewModelType.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/26.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
