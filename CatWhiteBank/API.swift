//
//  LoginFunc.swift
//  CatWhiteBank
//
//  Created by Daniel on 6/8/2025.
//

import Foundation

func Account(login: Bool,username: String, password: String, completion: @escaping (Bool) -> Void) {
    // 定义 API 地址（请替换为你的实际地址）
    guard let url = URL(string: login ? "https://danielk.top/App/CatWhiteBank/login.php" : "https://danielk.top/App/CatWhiteBank/signup.php") else {
        completion(false)
        return
    }
    
    // 创建请求
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    // 构建 POST 参数
    let postData = "username=\(username)&password=\(password)".data(using: .utf8)
    request.httpBody = postData
    
    // 发送请求
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // 检查错误
        if error != nil {
            completion(false)
            return
        }
            
        // 检查响应状态码
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(false)
            return
        }
            
        // 检查返回数据
        guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
            completion(false)
            return
        }
            
        // 判断返回结果
        completion(responseString == "true")
    }
        
    task.resume()
}

func GetUserMoney(username: String, completion: @escaping (Double) -> Void) {
    // 验证URL
    guard let url = URL(string: "https://danielk.top/App/CatWhiteBank/GetUserMoney.php") else {
        completion(0)
        return
    }
    
    // 创建POST请求
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    // 对用户名进行URL编码（处理特殊字符）
    guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        completion(0)
        return
    }
    let postData = "username=\(encodedUsername)".data(using: .utf8)
    request.httpBody = postData
    
    // 发送网络请求
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // 错误处理链
        guard error == nil else {
            completion(0)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(0)
            return
        }
        
        guard let data = data else {
            completion(0)
            return
        }
        
        guard let responseString = String(data: data, encoding: .utf8) else {
            completion(0)
            return
        }
        
        // 解析为Double，失败则返回0
        let money = Double(responseString) ?? 0
        completion(money)
    }
    
    task.resume()
}

func minusUserMoney(
    username: String,
    password: String,
    amount: Double,
    completion: @escaping (Bool, String, Double) -> Void
) {
    // 验证金额是否为正数
    guard amount > 0 else {
        completion(false, "扣除金额必须为正数", 0)
        return
    }
    
    // 验证URL
    guard let url = URL(string: "https://danielk.top/App/CatWhiteBank/minusMoney.php") else {
        completion(false, "无效的服务器地址", 0)
        return
    }
    
    // 创建POST请求
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    // 对参数进行URL编码（处理特殊字符）
    guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        completion(false, "参数编码失败", 0)
        return
    }
    
    // 构建POST参数（金额保留两位小数）
    let postData = String(
        format: "username=%@&password=%@&amount=%.2f",
        encodedUsername,
        encodedPassword,
        amount
    ).data(using: .utf8)
    request.httpBody = postData
    
    // 发送网络请求
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // 处理网络错误
        if let error = error {
            completion(false, "网络错误：\(error.localizedDescription)", 0)
            return
        }
        
        // 检查HTTP响应状态
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(false, "无效的服务器响应", 0)
            return
        }
        
        // 读取返回数据
        guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
            completion(false, "未收到服务器数据", 0)
            return
        }
        
        // 处理不同状态码
        switch httpResponse.statusCode {
        case 200:
            // 解析成功消息（尝试提取最新余额）
            let balance = extractBalance(from: responseString)
            completion(true, responseString, balance)
        case 405:
            completion(false, "服务器不支持该请求方式", 0)
        case 400:
            completion(false, "参数错误，请检查输入", 0)
        case 500:
            completion(false, "服务器内部错误", 0)
        default:
            completion(false, "请求失败（状态码：\(httpResponse.statusCode)）：\(responseString)", 0)
        }
    }
    
    task.resume()
}

/// 从服务器返回的字符串中提取余额
private func extractBalance(from responseString: String) -> Double {
    // 匹配类似 "当前余额: 19983.82" 中的数字
    let pattern = "当前余额: (\\d+\\.\\d+)"
    let regex = try? NSRegularExpression(pattern: pattern)
    if let match = regex?.firstMatch(
        in: responseString,
        range: NSRange(responseString.startIndex..., in: responseString)
    ) {
        let balanceRange = match.range(at: 1)
        if let range = Range(balanceRange, in: responseString) {
            return Double(responseString[range]) ?? 0
        }
    }
    return 0
}



/// 无需密码验证的增加用户金额函数
/// - Parameters:
///   - username: 用户名
///   - amount: 要增加的金额（必须为正数）
///   - completion: 回调结果（是否成功、最新余额）
func plusMoney(
    username: String,
    amount: Double,
    completion: @escaping (Bool, Double) -> Void
) {
    // 验证金额是否为正数
    guard amount > 0 else {
        completion(false, 0)
        return
    }
    
    // 验证URL
    guard let url = URL(string: "https://danielk.top/App/CatWhiteBank/plusMoney.php") else {
        completion(false, 0)
        return
    }
    
    // 创建POST请求
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    // 对用户名进行URL编码
    guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        completion(false, 0)
        return
    }
    
    // 构建POST参数（金额保留两位小数）
    let postData = String(
        format: "username=%@&amount=%.2f",
        encodedUsername,
        amount
    ).data(using: .utf8)
    request.httpBody = postData
    
    // 发送网络请求
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // 处理网络错误
        if let error = error {
            print("网络错误: \(error.localizedDescription)")
            completion(false, 0)
            return
        }
        
        // 检查HTTP响应状态
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(false, 0)
            return
        }
        
        // 读取并解析返回数据
        guard let data = data else {
            completion(false, 0)
            return
        }
        
        // 解析JSON响应
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let success = json["success"] as? Bool ?? false
                let balance = (json["balance"] as? NSNumber)?.doubleValue ?? 0
                completion(success, balance)
            } else {
                completion(false, 0)
            }
        } catch {
            print("JSON解析错误: \(error.localizedDescription)")
            completion(false, 0)
        }
    }
    
    task.resume()
}

private func fetchData(apiURL:String) async -> String {
    var dataString : String?
    guard let url = URL(string: apiURL) else {
        dataString = "錯誤的URL"
        print(dataString!)
        return ""
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let decodedString = String(data: data, encoding: .utf8) {
            dataString = decodedString
            print(dataString!)
            return dataString!
        } else {
            dataString = "無法解碼"
            print(dataString!)
            return dataString!
        }
    } catch {
        dataString = "請求錯誤: \(error.localizedDescription)"
        print(dataString!)
        return dataString!
    }
}
