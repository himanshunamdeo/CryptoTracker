//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 30/10/25.
//

import SwiftUI

extension UIApplication {
        
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
