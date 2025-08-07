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
    @State private var MakeMoneyTimer: Timer?
    @State private var MakeMoneyWaitTimer: Timer?
    @State private var MakeMoneyWait : Int = 10
    @State var UserLevel : Double = 0.5
    @State var showCustomerServiceSheet : Bool = false
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
                
                ScrollView {
                    
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
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: 80))
                            
                            Text("+\(String(UserLevel))$")
                                .font(.title.bold())
                            
                            
                            Button("賺錢"){
                                plusMoney(username: username, amount: UserLevel) { success , _ in
                                    if success{
                                        print("+\(UserLevel)$")
                                    }else{
                                        print("error")
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(colorScheme == .light ? Color.black : Color.white).opacity(0.1))
                        }
                        .padding(.trailing)
                        
                    }
                    HStack{
                        VStack{
                            Image(systemName: "dollarsign.ring.dashed")
                                .font(.system(size: 80))
                            
                            Text(MakeMoneyTimer == nil ? "" : "\(MakeMoneyWait)s獲得$\(userMoney * 0.002)")
                                .frame(height: 20)
                            
                            Button(MakeMoneyTimer != nil ? "結束" : "開始自動賺錢"){
                                if MakeMoneyTimer == nil{
                                    
                                    MakeMoneyWaitTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                        if MakeMoneyWait == 1{
                                            MakeMoneyWait = 10
                                        }else{
                                            MakeMoneyWait = MakeMoneyWait - 1
                                        }
                                    }
                                    
                                    MakeMoneyTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
                                        let addMoney = userMoney * 0.002
                                        
                                        plusMoney(username: username, amount: addMoney) { success , _ in
                                            if success{
                                                print("+\(addMoney)$")
                                            }else{
                                                print("error")
                                                MakeMoneyTimer?.invalidate()
                                            }
                                        }
                                        
                                    }
                                    RunLoop.current.add(MakeMoneyTimer!, forMode: .common)
                                    RunLoop.current.add(MakeMoneyWaitTimer!, forMode: .common)
                                }else{
                                    MakeMoneyWait = 10
                                    MakeMoneyWaitTimer?.invalidate()
                                    MakeMoneyTimer?.invalidate()
                                    MakeMoneyTimer = nil
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.accentColor)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(colorScheme == .light ? Color.black : Color.white).opacity(0.1))
                        }
                        .padding(.leading)
                        
                        VStack{
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 80))
                                .padding()
                            
                            Text("我的客戶")
                                .font(.title.bold())
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(colorScheme == .light ? Color.black : Color.white).opacity(0.1))
                        }
                        .padding(.trailing)
                        .onTapGesture{
                            showCustomerServiceSheet = true
                        }
                        
                        
                    }
                    
                    HStack{
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
                        .padding(.leading)
                        
                        Spacer()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .padding(.leading)
                            
                    }
                }
            }
            .onAppear{
                GetUserMoney(username: username) { money in
                    userMoney = money
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    GetUserMoney(username: username) { money in
                        userMoney = money
                        //print(money)
                    }
                }
                RunLoop.current.add(timer!, forMode: .common)
            }
            
            .sheet(isPresented: $showRemittanceSheet) {
                RemittanceView()
            }
            .sheet(isPresented: $showCustomerServiceSheet) {
                CustomerServiceView()
            }
            .background{
                Image("bank_icon")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.1)
            }
            .animation(.easeInOut, value: userMoney)
            
        }else{
            ContentView()
        }
    }
}

#Preview {
    HomePageView()
}
