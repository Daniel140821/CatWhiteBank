//
//  SignUpView.swift
//  CatWhiteBank
//
//  Created by Daniel on 6/8/2025.
//

import SwiftUI

struct SignUpView: View {
    @AppStorage("username") var username : String = ""
    @AppStorage("password") var password : String = ""
    @State var UnOrPwError : Bool = false
    @State var goLoginView : Bool = false
    @State var confirmPassword : String = ""
    @State var SignUpError : Bool = false
    @State var PwOrConfPwError : Bool = false
    @AppStorage("WasLogin") var WasLogin : Bool = false
    var body: some View {
        if WasLogin{
            HomePageView()
        }else if goLoginView{
            LoginView()
        }else{
            VStack{
                Label {
                    Text("註冊")
                } icon: {
                    Image(systemName: "pencil.and.list.clipboard")
                }.font(.largeTitle.bold())
                
                Spacer()
                
                LabeledContent {
                    TextField("必填",text: $username)
                        .padding()
                        .background{
                            Capsule()
                                .fill(Color(.secondarySystemFill))
                        }
                        .submitLabel(.done)
                } label: {
                    Text("用戶名稱")
                }.padding()
                
                LabeledContent {
                    SecureField("必填",text: $password)
                        .padding()
                        .background{
                            Capsule()
                                .fill(Color(.secondarySystemFill))
                        }
                        .submitLabel(.done)
                } label: {
                    Text("密碼")
                }.padding()
                
                LabeledContent {
                    SecureField("必填",text: $confirmPassword)
                        .padding()
                        .background{
                            Capsule()
                                .fill(Color(.secondarySystemFill))
                        }
                } label: {
                    Text("確認密碼")
                }.padding()
                
                Spacer()
                
                Button {
                    if username != "" && password != "" && confirmPassword != ""{
                        if password == confirmPassword{
                            Account(login: false, username: username, password: password) { success in
                                if success{
                                    SignUpError = false
                                    WasLogin = true
                                    print("SignUp success")
                                }else{
                                    SignUpError = true
                                    WasLogin = false
                                    print("SignUp not success")
                                }
                            }
                        }else{
                            PwOrConfPwError = true
                        }
                    }else{
                        UnOrPwError = true
                    }
                } label: {
                    
                    Text("註冊")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.accentColor)
                .padding()
                
                HStack(spacing: 0){
                    Text("已有帳號？")
                    Button("立即登入！"){
                        withAnimation{
                            goLoginView = true
                        }
                    }
                }.font(.title3)
            }
            .padding()
            .alert("提示", isPresented: $SignUpError) {
                Button("OK"){}
            } message: {
                Text("註冊失敗。")
            }
            .alert("提示", isPresented: $UnOrPwError) {
                Button("OK"){}
            } message: {
                Text("請輸入用戶名稱、密碼及確認密碼。")
            }
            .alert("提示", isPresented: $PwOrConfPwError) {
                Button("OK"){}
            } message: {
                Text("密碼不等於確認密碼，請重新輸入。")
            }
            .onAppear{
                password = ""
                username = ""
            }
        }
    }
}

#Preview {
    SignUpView()
}
