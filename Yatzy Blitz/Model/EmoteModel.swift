import SwiftUI

class EmoticonAnimator: ObservableObject {

    struct Emoticon {
        var id: UUID = UUID()
        var symbol: String
        var offset: CGFloat = UIScreen.main.bounds.height / 2
        var opacity: Double = 1.0
        var rotation: Double = 0
    }
    
    @Published var floatingEmoticons: [Emoticon] = []
    
    func startEmoticonAnimation(emote: String) {
        let emoticon = Emoticon(symbol: emote)
        floatingEmoticons.append(emoticon)
        animateEmoticon(emoticon)
    }
    
    private func animateEmoticon(_ emoticon: Emoticon) {
        withAnimation(Animation.easeOut(duration: 3.0)) {
            if let index = self.floatingEmoticons.firstIndex(where: { $0.id == emoticon.id }) {
                self.floatingEmoticons[index].offset -= 300
                self.floatingEmoticons[index].rotation = Double.random(in: -20...20)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if let index = self.floatingEmoticons.firstIndex(where: { $0.id == emoticon.id }) {
                withAnimation(Animation.easeOut(duration: 1.5)) {
                    self.floatingEmoticons[index].opacity = 0.0
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            if let index = self.floatingEmoticons.firstIndex(where: { $0.id == emoticon.id }) {
                self.floatingEmoticons.remove(at: index)
            }
        }
    }
}
