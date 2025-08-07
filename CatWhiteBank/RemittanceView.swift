//
//  RemittanceView.swift
//  CatWhiteBank
//
//  Created by Daniel on 7/8/2025.
//

import SwiftUI

struct RemittanceView: View {
    @AppStorage("password") var password : String = ""
    @AppStorage("username") var username : String = ""
    @State var AmountString : String = "0"
    @State var HisUsername : String = ""
    @State var UserPassword : String = ""
    @State var error : Bool = false
    @State var moneyHisUnAndPwIsNil : Bool = false
    @State var showAlert : Bool = false
    var body: some View {
        VStack{
            HStack{
                Text("滙款")
                    .font(.largeTitle.bold())
                    .padding()
                Spacer()
            }
            
            Spacer()
            
            LabeledContent {
                TextField("必填",text: $AmountString)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background{
                        Capsule()
                            .fill(Color(.secondarySystemFill))
                    }
                    .submitLabel(.done)
                    .onChange(of: AmountString) { oldValue, newValue in
                        if AmountString == "."{
                            AmountString = ""
                        }
                    }
            } label: {
                Text("金額")
            }.padding()
            
            
            
            LabeledContent {
                TextField("必填",text: $HisUsername)
                    .padding()
                    .background{
                        Capsule()
                            .fill(Color(.secondarySystemFill))
                    }
                    .submitLabel(.done)
                    .onChange(of: AmountString) { oldValue, newValue in
                        if AmountString == "."{
                            AmountString = ""
                        }
                    }
            } label: {
                Text("對方用戶名稱")
            }.padding()
            
            LabeledContent {
                SecureField("必填",text: $UserPassword)
                    .padding()
                    .background{
                        Capsule()
                            .fill(Color(.secondarySystemFill))
                    }
                    .submitLabel(.done)
                    .onChange(of: AmountString) { oldValue, newValue in
                        if AmountString == "."{
                            AmountString = ""
                        }
                    }
            } label: {
                Text("您的密碼")
            }.padding()
            
            Button {
                if AmountString.isEmpty && HisUsername.isEmpty && UserPassword.isEmpty{
                    error = true
                    showAlert = true
                }else{
                    if UserPassword == password{
                        plusMoney(username: HisUsername, amount: Double(AmountString) ?? Double(0)) { success , _ in
                            if success{
                                minusUserMoney(username: username, password: UserPassword, amount: Double(AmountString) ?? Double(0)) { isSuccess, message, balance in
                                    // 在主线程更新UI
                                    DispatchQueue.main.async {
                                        if isSuccess {
                                            print("操作成功：\(message)")
                                            print("最新余额：\(balance)")
                                            showAlert = true
                                            error = false
                                        } else {
                                            print("操作失败：\(message)")
                                            showAlert = true
                                            error = true
                                        }
                                    }
                                }
                            }else{
                                showAlert = true
                                error = true
                            }
                        }
                    }else{
                        error = false
                        showAlert = true
                    }
                }
            } label: {
                Text("滙款")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.accentColor)
            .padding()
            
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .alert("提示", isPresented: $showAlert) {
            Button("確認"){}
        } message: {
            if error{
                if AmountString.isEmpty || HisUsername.isEmpty || UserPassword.isEmpty{
                    Text("請填寫完整的資料。")
                }else if UserPassword != password{
                    Text("請確保資料填寫正確。")
                }else{
                    Text("請確保資料填寫正確。")
                }
            }else{
                Text("匯款成功！")
            }
        }
    }
}

#Preview {
    RemittanceView()
}
