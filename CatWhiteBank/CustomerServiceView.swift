//
//  CustomerServiceView.swift
//  CatWhiteBank
//
//  Created by Daniel on 7/8/2025.
//

import SwiftUI

struct CustomerServiceView: View {
    @Environment(\.colorScheme) var colorScheme
        
        @State private var question: String = ""
        
        @State private var ChatContent : [String] = []
        
        var body: some View {
            GeometryReader{Proxy in
                ScrollView(.vertical){
                    if ChatContent != []{
                        VStack{
                            
                            ForEach(0..<ChatContent.count, id: \.self) { index in
                                
                                var isAI: Bool {
                                    return ChatContent[index].contains("<aiIdentifierForAPP?>")
                                }
                                
                                VStack{
                                    
                                    Text(removeIdentifier(str:ChatContent[index]))
                                        .padding()
                                        .foregroundColor(.white)
                                        .textSelection(.enabled)
                                        .background{
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(isAI ? Color(.systemGray2).gradient : Color(.blue).gradient)
                                        }
                                }
                                .frame(maxWidth: .infinity, alignment: isAI ? .leading : .trailing)
                            }
                            
                        }.padding()
                    }else{
                        VStack{
                            Image("Cat_Image")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(.infinity)
                                .shadow(color: colorScheme == .light ? Color(.systemGray) : .clear, radius: colorScheme == .light ? 6 : 0)
                                .padding()
                            
                            Text("您好!")
                                .font(.title.bold())
                            Text("我是你的客戶 豹豹")
                                .font(.title.bold())
                        }
                        .frame(minHeight: Proxy.size.height)
                        .frame(maxWidth: .infinity)
                    }
                }.animation(.easeInOut, value: ChatContent)
            }.padding(.top)
            
            Spacer()
            
            VStack {
                TextField("你想問些什麼？",text: $question)
                    .padding(.horizontal)
                    .submitLabel(.send)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(.infinity)
                    .onSubmit {
                        print(question)
                        
                        ChatContent.append("<userIdentifierForAPP?>\(removeIdentifier(str: question))")
                        
                        let randomNumber : Int = Int.random(in: 1...300)
                        
                        let punctuationMarks = ["。", "！", "？"]
                        
                        
                        ChatContent.append("<aiIdentifierForAPP?>\(String(repeating: "喵", count: randomNumber))\(punctuationMarks.randomElement() ?? "。")")
                        
                        question = ""

                    }
            }
            .padding()
        }
        
        
        private func removeIdentifier(str:String) -> String{
            return str.replacingOccurrences(of: "<aiIdentifierForAPP?>", with: "").replacingOccurrences(of: "<userIdentifierForAPP?>", with: "")
        }
}

#Preview {
    CustomerServiceView()
}
