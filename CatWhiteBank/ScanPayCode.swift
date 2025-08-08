//
//  ScanPayCode.swift
//  CatWhiteBank
//
//  Created by Daniel on 8/8/2025.
//

import SwiftUI

struct ScanPayCode: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("username") var username : String = ""
    let isPayCodeURLTestString : String = "https://danielk.top/App/CatWhiteBank/PayCodeJSON.php?username="
    @State var PayCodeURL : String?
    @State var StartScan : Bool = true
    var body: some View {
        if StartScan{
            QRScanner(isPresented: $StartScan) { code in
                if code.contains(isPayCodeURLTestString){
                    PayCodeURL = code
                    playSound(sound: "beep", type: "mp3")
                    StartScan = false
                }
            }
            .ignoresSafeArea(.all)
            .onDisappear{
                Task {
                    let StringJsonData : String = await fetchData(apiURL: PayCodeURL ?? "")
                    
                    if let jsonData = StringJsonData.data(using: .utf8) {
                        do {
                            let data = try JSONDecoder().decode(PayCodeModel.self, from: jsonData)
                            
                            plusMoney(username: username, amount: Double(data.amount) ?? 0) { success, _ in
                                if success{
                                    minusUserMoney(username: data.username, password: data.password, amount: Double(data.amount) ?? 0) { isSuccess, message, balance in
                                        // 在主线程更新UI
                                        DispatchQueue.main.async {
                                            if isSuccess {
                                                print("操作成功：\(message)")
                                                print("最新余额：\(balance)")
                                                
                                                dismiss()
                                            } else {
                                                print("操作失败：\(message)")
                                                print("error")
                                            }
                                        }
                                    }
                                }else{
                                    print("error")
                                }
                            }
                        } catch {
                            // 处理解码错误
                            print("解码失败: \(error.localizedDescription)")
                            print("错误详情: \(error)")
                        }
                    } else {
                        // 处理字符串转数据失败的情况
                        print("无法将字符串转换为数据")
                    }
                    
                }
            }
        }
    }
}

#Preview {
    ScanPayCode()
}
