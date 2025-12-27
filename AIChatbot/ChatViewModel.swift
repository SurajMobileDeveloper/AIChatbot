import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    
    @Published var messages: [Message] = [
        Message(text: "Hello! Can I help you?", sender: .bot, isTyping: false)
    ]
    
    // MARK: - Send User Message
    func sendUserMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        messages.append(
            Message(text: trimmed, sender: .user, isTyping: false)
        )
        
        fetchBotResponse(for: trimmed)
    }
    
    // MARK: - Gemini API Call
    private func fetchBotResponse(for userText: String) {
        let apiKey = GenAIConfig.apiKey
        // add typing bubble
        messages.append(
            Message(text: "", sender: .bot, isTyping: true)
        )
        
        let urlString =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": userText]
                    ]
                ]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                self.replaceTypingWith(text: "Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                self.replaceTypingWith(text: "No response from server")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                let text =
                (((json?["candidates"] as? [[String: Any]])?.first?["content"]
                  as? [String: Any])?["parts"] as? [[String: Any]])?.first?["text"] as? String
                
                self.replaceTypingWith(text: text ?? "No reply received")
                
            } catch {
                self.replaceTypingWith(text: "Failed to parse response")
            }
            
        }.resume()
    }
    
    // MARK: - Replace typing bubble
    private func replaceTypingWith(text: String) {
        DispatchQueue.main.async {
            if let index = self.messages.lastIndex(where: {
                $0.sender == .bot && $0.isTyping
            }) {
                self.messages[index].text = text
                self.messages[index].isTyping = false
            }
        }
    }
}

enum GenAIConfig {
    static var apiKey: String {
        guard
            let url = Bundle.main.url(forResource: "GenerativeAI-Info", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ) as? [String: Any],
            let key = plist["API_KEY"] as? String
        else {
            fatalError("❌ API Key not found in GenAi-info.plist")
        }
        
        return key
    }
}

