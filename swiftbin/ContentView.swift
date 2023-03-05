//
//  ContentView.swift
//  swiftbin
//
//  Created by Jeffery You on 2/25/23.
//

import SwiftUI

struct ContentView: View {
    @State private var serverUrl: String = UserDefaults.standard.string(forKey: "serverUrl") ?? ""
    @State private var token: String = UserDefaults.standard.string(forKey: "token") ?? ""
    @State private var testState: TestState = .notStarted
    
    enum TestState {
        case notStarted
        case inProgress
        case succeed
        case failed
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
            Divider()
            HStack() {
                Text("Server URL:").multilineTextAlignment(.trailing).padding().frame(width: 110, alignment: .leading)
                TextField("Enter server URL", text: $serverUrl)
            }
            HStack {
                Text("Token:").multilineTextAlignment(.trailing).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(width: 110, alignment: .leading)
                SecureField("Enter token", text: $token)
            }
            HStack {
                Spacer()
                    .frame(width: 118.0, height: 1.0)
                Button(action: testConfig ) {
                    Text("Test and Save")
                }
                if testState == .inProgress {
                    ProgressView()
                } else if testState == .succeed {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                } else if testState == .failed {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                } else if testState == .notStarted {
                    Image(systemName: "circle")
                        .foregroundColor(.black)
                }
                
            }
        }
        .padding([.leading, .bottom, .trailing])
        .frame(width: 400.0, height: 250)
        
    }
    
    private func saveConfig() {
        UserDefaults.standard.set(serverUrl, forKey: "serverUrl")
        UserDefaults.standard.set(token, forKey: "token")
    }
    private func testConfig() {
        testState = .inProgress
        Utils.testConfig(serverUrl: serverUrl, token: token) { success in
            if success {
                saveConfig()
            }
            DispatchQueue.main.async {
                testState = success ? .succeed : .failed
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
