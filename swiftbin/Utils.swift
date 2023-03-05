//
//  Utils.swift
//  swiftbin
//
//  Created by Jeffery You on 3/4/23.
//

import AppKit

class Utils {
    private static func setClipboard(text: String) {
        print("Set clipboard: \(text)")
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    private static func getClipboard() -> String {
        let pasteboard = NSPasteboard.general
        let pasteboardItems = pasteboard.pasteboardItems ?? []
        let pasteboardItem = pasteboardItems.first
        let pasteboardString = pasteboardItem?.string(forType: .string) ?? ""
        print("Current clipboard: \(pasteboardString)")
        return pasteboardString
    }
    
    static func copy(serverUrl: String) {
        print("Start copy")
        let url = URL(string: "\(serverUrl)/plain")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            guard let data = data,
                  error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }
            setClipboard(text: String(data: data, encoding: .utf8)!)
        }
        task.resume()
        semaphore.wait()
    }
    
    static func paste(serverUrl: String, token: String) {
        print("Start paste")
        let url = URL(string: "\(serverUrl)/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        
        let text = getClipboard()
        request.httpBody = text.data(using: .utf8)
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                print("Paste successful")
            } else {
                print("Invalid response")
            }
        }
        task.resume()
        semaphore.wait()
    }
    
    static func testConfig(serverUrl: String, token: String, completion: @escaping (Bool) -> Void) {
        let text = UUID().uuidString
        setClipboard(text: text)
        Utils.paste(serverUrl: serverUrl, token: token)
        setClipboard(text: "")
        Utils.copy(serverUrl: serverUrl)
        if(text == getClipboard()) {
            print("Succeed")
            completion(true)
        } else {
            print("Failed")
            completion(false)
        }
    }
}
