import SwiftUI

struct BackgroundButton: View {
    
    @Binding var isPressed: Bool
    
    var image: String
    var pressedImage: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {}
            .buttonStyle(ChangeBackgroundStyling(image: image, pressedImage: pressedImage, isPressed: isPressed))
            .pressAction {
                isPressed = true
            } onRelease: {
                isPressed = false
            }
    }
}
struct ChangeBackgroundStyling: ButtonStyle {
    var image: String
    var pressedImage: String
    var isPressed: Bool
    func makeBody(configuration: Configuration) -> some View {
        Image(isPressed ? pressedImage : image)
            .animation(nil)
    }
}
