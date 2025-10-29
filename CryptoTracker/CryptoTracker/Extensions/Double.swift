//
//  Double.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 28/10/25.
//

import Foundation

extension Double {
    
    
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    func asCurrencyWith2Decimals() -> String {
        currencyFormatter2.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    func asCurrencyWith6Decimals() -> String {
        currencyFormatter6.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    func asNumberString() -> String {
        String(format: "%.2f", self)
    }
    
    func asPercentString() -> String {
        asNumberString() + "%"
    }
}
