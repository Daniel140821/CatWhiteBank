//
//  StringToValidNumber.swift
//  CatWhiteBank
//
//  Created by Daniel on 8/8/2025.
//

import Foundation

func toValidNumber(_ input: String) -> Double {
    // 移除空格
    let str = input.trimmingCharacters(in: .whitespaces)
    
    // 空字符串处理为0
    if str.isEmpty {
        return 0
    }
    
    // 检查科学计数法或负数
    if str.lowercased().contains("e") || str.hasPrefix("-") {
        return 0
    }
    
    // 检查小数点数量（不能超过1个）
    let dotCount = str.filter { $0 == "." }.count
    if dotCount > 1 {
        return 0
    }
    
    // 检查小数点后是否有数字
    if let dotIndex = str.firstIndex(of: "."),
       dotIndex == str.index(before: str.endIndex) {
        return 0
    }
    
    // 尝试转换为数字并确保非负
    guard let num = Double(str), num >= 0 else {
        return 0
    }
    
    return num
}
