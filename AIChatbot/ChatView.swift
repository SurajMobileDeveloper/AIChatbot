//
//  ContentView.swift
//  AIChatbot
//
//  Created by Suraj Sharma on 26/12/25.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText = ""
    
    var body: some View {
        VStack {
            List(viewModel.messages) { msg in
                           MessageBubble(message: msg)
                               .listRowSeparator(.hidden)
                               .listRowInsets(
                                   EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                               )
                       }
                       .listStyle(.plain)
                       .listRowBackground(Color.clear)
                       .onChange(of: viewModel.messages.count) { _ in
                          scrollToBottom()
                       }
            
            HStack {
                TextField("Please type..", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 36)
                
                Button(action: sendMessage) {
                    Text("Send")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    func sendMessage() {
        viewModel.sendUserMessage(inputText)
        inputText = ""
    }
    // MARK: - Scroll
        private func scrollToBottom() {
            DispatchQueue.main.async {
                guard let last = viewModel.messages.last else { return }
                withAnimation {
                    // List auto-handles scroll reuse
                    _ = last.id
                }
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
