import SwiftUI

struct EmoteView: View {
    
    @Binding var emoteView: Bool
    var multiplayerModel: MultiplayerModel
    var animateEmoticon: (String) -> Void
    let emoticons: [[String]] = [["😀", "😉", "😍", "🤩", "😜"], ["🤔", "🙄", "😎", "😇", "😂"], ["🥰", "😅", "😤", "😱", "😓"]]
        func encode(_ s: String) -> String {
            let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
            return String(data: data, encoding: .utf8)!
        }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        emoteView = false
                    }
                
                VStack(spacing: 10) {
                    ForEach(0..<emoticons.count, id: \.self) { rowIndex in
                        HStack(spacing: 10) {
                            ForEach(self.emoticons[rowIndex], id: \.self) { emote in
                                EmoticonButton(emote: emote, action: {
                                    emoteView = false
                                }, animate: {
                                    animateEmoticon(emote)
                                    multiplayerModel.sendEmoji(emoji: encode(emote))
                                })
                                .font(.system(size: min(geometry.size.width / 8, 50)))
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                .background(Color.white.cornerRadius(8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 3))
            }
        }
    }
}

struct EmoticonButton: View {
    let emote: String
    let action: () -> Void
    let animate: () -> Void
    init(emote: String, action: @escaping () -> Void, animate: @escaping () -> Void) {
        self.emote = emote
        self.action = action
        self.animate = animate
    }
    init(emote: String, action: @escaping () -> Void) {
        self.emote = emote
        self.action = action
        self.animate = {}
    }
    var body: some View {
        Button(action: {
            animate()
            action()
        }) {
            Text(emote)
        }
    }
}
