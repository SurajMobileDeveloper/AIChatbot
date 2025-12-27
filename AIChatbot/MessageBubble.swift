import SwiftUI

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.sender == .bot {
                // Bot message on left
                
                Image("bot_avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(Circle())
                Group {
                    if message.isTyping {
                        TypingDotsView()
                    } else {
                        Text(message.text)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(ChatBubbleShape())
                .frame(maxWidth: 250, alignment: .leading)
                Spacer()
            } else {
                // User message on right
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .clipShape(ChatBubbleShape(isFromUser: true))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true) 
                    .cornerRadius(15)
                    .frame(maxWidth: 250, alignment: .trailing)
                    .fixedSize(horizontal: false, vertical: true)
                UserAvatar()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct ChatBubbleShape: Shape {
    var isFromUser: Bool = false
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius: CGFloat = 16
        let tailWidth: CGFloat = 8
        let tailHeight: CGFloat = 10
        
        let tailYOffset = rect.height - 20 // tail at bottom
        
        if isFromUser {
            // USER (RIGHT)
            path.addRoundedRect(
                in: CGRect(
                    x: 0,
                    y: 0,
                    width: rect.width - tailWidth,
                    height: rect.height
                ),
                cornerSize: CGSize(width: radius, height: radius)
            )
            
            path.move(to: CGPoint(x: rect.width - tailWidth, y: tailYOffset))
            path.addLine(to: CGPoint(x: rect.width, y: tailYOffset + tailHeight / 2))
            path.addLine(to: CGPoint(x: rect.width - tailWidth, y: tailYOffset + tailHeight))
            
        } else {
            // BOT (LEFT)
            path.addRoundedRect(
                in: CGRect(
                    x: tailWidth,
                    y: 0,
                    width: rect.width - tailWidth,
                    height: rect.height
                ),
                cornerSize: CGSize(width: radius, height: radius)
            )
            
            path.move(to: CGPoint(x: tailWidth, y: tailYOffset))
            path.addLine(to: CGPoint(x: 0, y: tailYOffset + tailHeight / 2))
            path.addLine(to: CGPoint(x: tailWidth, y: tailYOffset + tailHeight))
        }
        
        return path
    }
}

struct UserAvatar: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Image(systemName: "person.fill")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium))
        }
        .frame(width: 52, height: 52)
        .clipShape(Circle())
    }
}


struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(text: "hello", sender: .bot, isTyping: false))
    }
}
