//
//  SetApi.swift
//  LegalAdvice
//
//  Created by Rakan on 2023/8/30.
//

import SwiftUI
import ChatGPTSwift


//class APIManager: ObservableObject {
//    @Published var api = ChatGPTAPI(apiKey: "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")
//}


//class APIManager: ObservableObject {
//    @Published
//    @APIKey("apiKey", default: "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")
//    var apiKey: String
//    init() {
//            
//    }
//}
//

//struct SetApi: View {
//    @EnvironmentObject var apiManager: APIManager // 引入环境对象
//    @State private var apiKey: String = "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"
//
//    var body: some View {
//        VStack {
//            TextField("API Key", text: $apiKey) // 修改环境对象中的 api 值
//
//            Button(action: {
//                apiManager.api = ChatGPTAPI(apiKey: apiKey)
//                print("新的 API 值为: \(apiKey)")
//            }) {
//                Text("保存")
//            }
//        }
//    }
//}
//struct SetApi: View {
//    @EnvironmentObject var apiManager: APIManager
//    @State private var isShowingAlert = false
//    
//    var body: some View {
//        
//        VStack {
//            @State var key = apiManager.apiKey
//            TextField("API Key", text: $key)
//
//            Button(action: {
//                apiManager.apiKey=key
//                print("新的 API 值为: \(apiManager.apiKey)")
//                self.isShowingAlert = true
//            }) {
//                Text("保存")
//            }
//            .alert(isPresented: $isShowingAlert) {
//                Alert(
//                    title: Text("成功设置新的api"),
//                    message: Text("新的api为\(apiManager.apiKey)"),
//                    dismissButton: .default(Text("确定"))
//                )
//            }
//        }
//        
//    }
//}



class APIManager: ObservableObject {
    @AppStorage("apiKey")
    var apiKey: String = "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"
    
    init() { }
}

struct SetApi: View {
    @EnvironmentObject var apiManager: APIManager
    @State private var isShowingAlert = false
    @State private var key: String
    
    init(apiManager: APIManager) {
        _key = State(initialValue: apiManager.apiKey)
    }
    
    var body: some View {
        VStack {
            TextField("API Key", text: $key)

            Button(action: {
                apiManager.apiKey=key
                print("新的 API 值为: \(apiManager.apiKey)")
                self.isShowingAlert = true
            }) {
                Text("保存")
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("成功设置新的api"),
                    message: Text("新的api为\(apiManager.apiKey)"),
                    dismissButton: .default(Text("确定"))
                )
            }
        }
    }
}

struct SetApi_Previews: PreviewProvider {
    static var previews: some View {
        SetApi(apiManager: APIManager())
            .environmentObject(APIManager())
    }
}


//#Preview {
//    SetApi(apiManager: APIManager())
//        .environmentObject(APIManager())
//}
