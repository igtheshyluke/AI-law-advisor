//
//  ContentView.swift
//  LegalAdvice
//
//  Created by Rakan on 2023/8/7.
//

import SwiftUI

import ChatGPTSwift





struct ContentView: View {
    @State private var inputText = ""
    @State private var messages: [Message] = []
    @State private var currentMessageID: UUID?
    @State private var textSend = ""
    @State private var isTyping = false
    
    private func findMessage(withID id: UUID) -> Message? {
        return messages.first(where: { $0.id == id })
    }
    
    private func updateMessageText(id:UUID, newText: String) {
        if let index = messages.firstIndex(where: { $0.id == id }) {
            messages[index].text = newText
        }
    }
    
    
    
    let api = ChatGPTAPI(apiKey: "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")
    
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text("法律咨询")
                ScrollView {
                    Spacer()
                    ForEach(messages) { message in
                        HStack(alignment: .top, content: {
                            
                            if message.isFromUser{
                                Spacer()
                                Text(message.text)
                                    .padding(.all)
                                    .background(.gray.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .frame(alignment: .leading)
                                
                                ZStack {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                    Text("ME")
                                        .font(.title2)
                                        .foregroundColor(Color.white)
                                    
                                }.padding(.trailing,15)
                                
                            }else{
                                ZStack {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                    Text("AI")
                                        .font(.title2)
                                        .foregroundColor(Color.white)
                                }
                                Text(message.text)
                                    .padding(.all)
                                    .background(.gray.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .frame(alignment: .leading)
                                Spacer()
                            }
                            
                        })
                        .padding(.leading, 10.0)
                    }
                }
                
                VStack {
                    Group {
                        TextField("输入你的问题",
                                  text: $textSend,
                                  onEditingChanged: { isEditing in
                            
                        })
                        .padding()
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { _ in
                            if !isTyping{
                                let newMessage=Message(text: textSend, isFromUser: true)
                                currentMessageID=newMessage.id
                                messages.append(newMessage)
                            }
                            
                            isTyping=true
                            if let index = messages.firstIndex(where: { $0.id == currentMessageID }) {
                                messages[index].text = textSend
                                
                            }
                            print("Text changed: \(textSend)")
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding([.top, .leading, .trailing])
                }
                
                
                
                HStack(spacing: 1.0) {
                    
                    
                    
                    Button(action:{
                        messages=[]
                        api.deleteHistoryList()
                        Task{
                            do {
                                let response = try await api.sendMessage(text: "I want you to act as my legal advisor and respond in Chinese. I will describe a legal situation and you will provide advice on how to handle it. You should only reply with your advice, and nothing else. Do not write explanations. My first request is [法律问题]")
                                
                                let newMessage = Message(text: response, isFromUser: false)
                                messages.append(newMessage)
                                print(response)
                                
                            } catch {
                                print(error.localizedDescription)
                                if let index = messages.firstIndex(where: { $0.text == "处理中" }) {
                                    messages.remove(at: index)
                                }
                                let newMessage = Message(text: error.localizedDescription, isFromUser: false)
                                messages.append(newMessage)
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.white)
                            Text("清除")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                    Spacer()
                        .frame(width: 50.0)
                    Button(action:{
                        let textSent = textSend
                        textSend=""
                        let processingMessage = Message(text: "处理中", isFromUser: false)
                        messages.append(processingMessage)
                        Task{
                            do {
                                let response = try await api.sendMessage(text: textSent)
                                print(textSent)
                                if let index = messages.firstIndex(where: { $0.text == "处理中" }) {
                                    messages.remove(at: index)
                                }
                                let newMessage = Message(text: response, isFromUser: false)
                                messages.append(newMessage)
                                print(response)
                                
                            } catch {
                                print(error.localizedDescription)
                                if let index = messages.firstIndex(where: { $0.text == "处理中" }) {
                                    messages.remove(at: index)
                                }
                                let newMessage = Message(text: error.localizedDescription, isFromUser: false)
                                messages.append(newMessage)
                            }
                        }
                        
                        
                        isTyping=false
                    }){
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                            Text("发送")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    
                }
                .padding()
                
                //                NavigationLink(destination: SetApi(apiManager: APIManager())
                //                    .environmentObject(APIManager())) {
                //                    Text("Go to Modify API")
                //                }
                
            }.background(Color(UIColor.systemGray6))
        }
        .navigationBarTitle("Main View")
        .onAppear{
            Task{
                do {
                    let response = try await api.sendMessage(text: "I want you to act as my legal advisor and respond in Chinese. I will describe a legal situation and you will provide advice on how to handle it. You should only reply with your advice, and nothing else. Do not write explanations. My first request is [法律问题]")
                    
                    let newMessage = Message(text: response, isFromUser: false)
                    messages.append(newMessage)
                    print(response)
                    
                } catch {
                    print(error.localizedDescription)
                    if let index = messages.firstIndex(where: { $0.text == "处理中" }) {
                        messages.remove(at: index)
                    }
                    let newMessage = Message(text: error.localizedDescription, isFromUser: false)
                    messages.append(newMessage)
                }
            }
        }
        
    }
}

struct Message: Identifiable {
    let id = UUID()
    var text: String
    let isFromUser: Bool
}




#Preview {
    ContentView()
}
