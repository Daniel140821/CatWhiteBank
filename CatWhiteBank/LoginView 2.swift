//
//  LoginView.swift
//  CatWhiteBank
//
//  Created by Daniel on 6/8/2025.
//

import SwiftUI

struct LoginView: View {
    @State var username : String = ""
    @State var password : String = ""
    @State var UnOrPwError : Bool = false
    @AppStorage("WasLogin") var WasLogin : Bool = false
    var body: some View {
        if WasLogin{
            
        }else{
            VStack{
                Label {
                    Text("登入")
                } icon: {
                    Image(systemName: "person.crop.circle")
                }.font(.largeTitle.bold())
                
                Spacer()
                
                LabeledContent {
                    TextField("必填",text: $username)
                        .padding()
                        .background{
                            Capsule()
                                .fill(Color(.secondarySystemFill))
                        }
                } label: {
                    Text("用戶名稱")
                }.padding()
                
                LabeledContent {
                    TextField("必填",text: $password)
                        .padding()
                        .background{
                            Capsule()
                                .fill(Color(.secondarySystemFill))
                        }
                } label: {
                    Text("密碼")
                }.padding()
                
                Spacer()
                
                Button {
                    Account(login: true, username: username, password: password) { success in
                        if success{
                            UnOrPwError = false
                            WasLogin = true
                            print("Login success")
                        }else{
                            UnOrPwError = true
                            WasLogin = false
                            print("Login not success")
                        }
                    }
                } label: {
                    
                    Text("登入")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.accentColor)
                .padding()
                
                HStack(spacing: 0){
                    Text("沒有帳號？")
                    Button("立即註冊！"){}
                }.font(.title3)
                    .alert("提示", isPresented: $UnOrPwError) {
                        Button("OK"){}
                    } message: {
                        Text(username.isEmpty || password.isEmpty ? "請輸入用戶名稱及密碼。" : "密碼或用戶名稱錯誤。")
                    }
                
                
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
