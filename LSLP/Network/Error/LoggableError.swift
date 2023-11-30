//
//  LoggableError.swift
//  LSLP
//
//  Created by 홍수만 on 2023/11/28.
//

import Foundation

protocol LoggableError: Error {
    var rawValue: Int { get }
    var errorDescription: String { get }
}
