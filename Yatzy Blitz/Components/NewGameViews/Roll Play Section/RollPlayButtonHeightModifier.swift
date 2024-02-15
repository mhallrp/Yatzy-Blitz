import SwiftUI

extension View {
    func customHeightForRollPlayView(landscape:Bool) -> some View {
        self.modifier(RollPlayButtonHeightModifier(landscape:landscape))
    }
}

struct RollPlayButtonHeightModifier: ViewModifier {
    @State var landscape:Bool
    func body(content: Content) -> some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                content
                    .frame(height: landscape ? UIScreen.main.bounds.height * 0.10 : UIScreen.main.bounds.height * 0.075)
            } else {
                content
            }
        }
    }
}
