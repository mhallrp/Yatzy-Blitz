import SwiftUI

struct EmoticonView: View {
    
    var emote: EmojiAnimator.Emoticon
    
    var body: some View {
        Text(emote.symbol)
            .font(.system(size: 50))
            .offset(y: emote.offset)
            .opacity(emote.opacity)
            .rotationEffect(Angle(degrees: emote.rotation))
    }
}
