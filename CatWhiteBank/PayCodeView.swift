//
//  PayCodeView.swift
//  CatWhiteBank
//
//  Created by Daniel on 8/8/2025.
//

import SwiftUI

struct PayCodeView: View {
    @State var userInputPassword : String = ""
    @State var userInputPasswordIsTrue : Bool = false
    @State var userInputPasswordIsNotTrue : Bool = false
    @State var showPlayCode : Bool = true
    @AppStorage("username") var username : String = ""
    @AppStorage("password") var password : String = ""
    @State var amount : String = "0"
    @State var jsonURL : URL?
    @State var CodeLink : URL?
    var body: some View {
        VStack{
            Spacer()
            
            VStack{
                
                HStack{
                    Label {
                        Text("付款碼")
                    } icon: {
                        Image(systemName: "qrcode")
                    }
                    .font(.title2)
                    .padding()
                    
                    Spacer()
                }
                
                Spacer()
                
                if userInputPasswordIsTrue{
                    if showPlayCode{
                        AsyncImage(url: CodeLink) { Image in
                            Image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ZStack{
                                ProgressView()
                                Image("")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }.onAppear{
                            jsonURL = URL(string: "https%3A%2F%2Fdanielk.top%2FApp%2FCatWhiteBank%2FPayCodeJSON.php%3Fusername%3D\(username)%26password%3D\(password)%26amount%3D\(amount)")
                            CodeLink = URL(string: "https://api.uomg.com/api/qrcode?url=\(jsonURL!)")
                        }
                    }
                    
                    LabeledContent {
                        TextField("請輸入金額",text: $amount)
                            .padding()
                            .background{
                                Capsule()
                                    .fill(Color(.secondarySystemFill))
                            }
                            .submitLabel(.continue)
                            .keyboardType(.decimalPad)
                            .onChange(of: amount, {
                                showPlayCode = false
                            })
                            .onSubmit{
                                amount = String(toValidNumber(amount))
                                
                                jsonURL = URL(string: "https%3A%2F%2Fdanielk.top%2FApp%2FCatWhiteBank%2FPayCodeJSON.php%3Fusername%3D\(username)%26password%3D\(password)%26amount%3D\(amount)")
                                CodeLink = URL(string: "https://api.uomg.com/api/qrcode?url=\(jsonURL!)")
                                
                                showPlayCode = true
                                
                                
                            }
                            
                    } label: {
                        Text("金額")
                    }
                    .padding(.horizontal)
                    
                    if !showPlayCode{
                        Button(action: {
                            amount = String(toValidNumber(amount))
                            
                            jsonURL = URL(string: "https%3A%2F%2Fdanielk.top%2FApp%2FCatWhiteBank%2FPayCodeJSON.php%3Fusername%3D\(username)%26password%3D\(password)%26amount%3D\(amount)")
                            CodeLink = URL(string: "https://api.uomg.com/api/qrcode?url=\(jsonURL!)")
                            
                            showPlayCode = true
                        }, label: {
                            Text("確認")
                                .padding(.horizontal)
                                .padding(.vertical,2)
                        })
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .padding()
                    }
                    
                    Spacer()
                    
                    Divider()
                        .padding()
                    
                    HStack{
                        Text("付款方式")
                            .padding(.horizontal)
                            .foregroundColor(Color(.secondaryLabel))
                        
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "dollarsign.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .orange)
                            .font(.largeTitle)
                            .padding(.leading)
                        
                        Text("銀行餘額")
                        
                        Spacer()
                        
                        Image(systemName: "checkmark")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding()
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.yellow.mix(with: .white, by: 0.7))
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                }else{
                    Text("請先輸入密碼")
                        .font(.title)
                        .padding()
                    
                    
                    
                    LabeledContent {
                        SecureField("請輸入該帳號的密碼",text: $userInputPassword)
                            .padding()
                            .background{
                                Capsule()
                                    .fill(Color(.secondarySystemFill))
                            }
                            .submitLabel(.done)
                            .onSubmit{
                                if password == userInputPassword{
                                    withAnimation{
                                        userInputPasswordIsTrue = true
                                        userInputPasswordIsNotTrue = false
                                    }
                                }else{
                                    userInputPasswordIsTrue = false
                                    userInputPasswordIsNotTrue = true
                                }
                            }
                    } label: {
                        Text("密碼")
                    }
                    .padding()
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Button(action: {
                        if password == userInputPassword{
                            withAnimation{
                                userInputPasswordIsTrue = true
                                userInputPasswordIsNotTrue = false
                            }
                        }else{
                            userInputPasswordIsTrue = false
                            userInputPasswordIsNotTrue = true
                        }
                    }, label: {
                        Text("確認")
                            .padding(.horizontal)
                            .padding(.vertical,2)
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .padding()
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            .frame(width: 380)
            .frame(height: 500)
            .background{
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
            }
            .padding()
            .alert("提示", isPresented: $userInputPasswordIsNotTrue) {
                Button("OK"){}
            } message: {
                Text("密碼錯誤。")
            }
            
            
            Spacer()
                
                

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.green)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    PayCodeView()
}
