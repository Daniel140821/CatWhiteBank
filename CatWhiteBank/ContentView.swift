//
//  ContentView.swift
//  CatWhiteBank
//
//  Created by Daniel on 6/8/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("WasLogin") var WasLogin : Bool = false
    @State var goLoginView : Bool = false
    @State var goSignUpView : Bool = false
    var body: some View {
        if WasLogin{
            HomePageView()
        }else if goLoginView{
            LoginView()
                .onDisappear{
                    goLoginView = false
                    goSignUpView = false
                }
        }else if goSignUpView{
            SignUpView()
                .onDisappear{
                    goLoginView = false
                    goSignUpView = false
                }
        }else{
            VStack {
                Image("Bank_Image")
                    .resizable()
                    .scaledToFit()
                
                Label {
                    Text("豹白銀行")
                } icon: {
                    Image("bank_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }.font(.largeTitle.bold())
                
                
                Button {
                    withAnimation{
                        goLoginView = true
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
                    Button("立即註冊！"){
                        withAnimation{
                            goSignUpView = true
                        }
                    }
                }.font(.title3)
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
