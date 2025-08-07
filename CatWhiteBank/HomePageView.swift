//
//  HomePageView.swift
//  CatWhiteBank
//
//  Created by Daniel on 7/8/2025.
//

import SwiftUI

struct HomePageView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("WasLogin") var WasLogin : Bool = false
    @AppStorage("username") var username : String = ""
    @State var userMoney : Double = 0
    @State var showRemittanceSheet : Bool = false
    @State private var timer: Timer?
    var body: some View {
        if WasLogin{
            VStack{
                HStack{
                    Text("您好 \(username)")
                        .font(.largeTitle.bold())
                        .padding()
                    
                    Spacer()
                    
                    Image("bank_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .padding(.horizontal)
                    
                }
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Text("餘額")
                            .font(.largeTitle)
                            .padding()
                        
                    }
                    
                    Text("\(String(userMoney))$")
                        .font(.largeTitle)
                        .padding()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(colorScheme == .light ? Color.black : Color.white).opacity(0.1))
                }
                .padding()
                
                HStack{
                    
                    VStack{
                        Text("滙款")
                            .padding()
                        
                        HStack{
                            Image(systemName: "dollarsign.circle")
                            Image(systemName: "chevron.forward.2")
                            Image(systemName: "person.crop.circle")
                        }
                        .padding()
                    }
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(colorScheme == .light ? Color.black : Color.white).opacity(0.1))
                    }
                    .padding(.leading)
                    .onTapGesture {
                        showRemittanceSheet = true
                    }
                    
                    VStack{
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 80))
                            .padding()
                        
                        Button("登出"){
                            WasLogin = false
                        }
                        .buttonStyle(.bordered)
                        .tint(.red.mix(with: .white, by: 0.05))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(colorScheme == .light ? Color.black : Color.white).opacity(0.1))
                    }
                    .padding(.trailing)
                    
                }
                
                Spacer()
            }
            .onAppear{
                GetUserMoney(username: username) { money in
                    userMoney = money
                    print(money)
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    GetUserMoney(username: username) { money in
                        userMoney = money
                        print(money)
                    }
                }
                RunLoop.current.add(timer!, forMode: .common)
                
                
            }
            
            .sheet(isPresented: $showRemittanceSheet) {
                RemittanceView()
            }
            .background{
                Image("bank_icon")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.1)
            }
            
        }else{
            ContentView()
        }
    }
}

#Preview {
    HomePageView()
}
