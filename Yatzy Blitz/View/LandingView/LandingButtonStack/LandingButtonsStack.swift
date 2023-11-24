import SwiftUI

struct LandingButtonsStack: View {
    
    @Binding var showMultiplayerOptions: Bool
    @Binding var navigationPath: [LandingView.NavigationDestination]
    @State var isPressed = [false, false, false]
    
    let presentMatchmakerAction: () -> Void
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.easeIn(duration: 0.2)) {
                    if !showMultiplayerOptions {
                        navigationPath = [.newAIGame]
                    } else {
                        navigationPath = [.localMultiplayer]
                    }
                }
            }) {}
                .pressAction { isPressed[0] = true }
        onRelease: { isPressed[0] = false }
                .buttonStyle(MainButtonView(text: !showMultiplayerOptions ? "Single Player" : "Local Multiplayer", isPressed: isPressed[0]))
            Button(action: {
                withAnimation(.easeIn(duration: 0.2)) {
                    if !showMultiplayerOptions {
                        showMultiplayerOptions = true
                    } else {
                        presentMatchmakerAction()
                    }
                }
            }) {}
                .pressAction { isPressed[1] = true }
        onRelease: { isPressed[1] = false }
                .buttonStyle(MainButtonView(text: !showMultiplayerOptions ? "Play Together" : "Online Multiplayer", isPressed: isPressed[1]))
        }
    }
}
