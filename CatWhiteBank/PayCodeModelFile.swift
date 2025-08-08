//
//  PayCodeModelFile.swift
//  CatWhiteBank
//
//  Created by Daniel on 8/8/2025.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let payCodeModel = try? JSONDecoder().decode(PayCodeModel.self, from: jsonData)

import Foundation

// MARK: - PayCodeModel
struct PayCodeModel: Codable {
    let username, password, amount, receivedAt: String

    enum CodingKeys: String, CodingKey {
        case username, password, amount
        case receivedAt = "received_at"
    }
}
