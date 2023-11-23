import SwiftUI

struct BackgroundPickerView: View {
    
    @AppStorage("backgroundImage") var backgroundImage = "redGradientBackground"
    @State private var isPressed: [Bool] = Array(repeating: false, count: 3)

    var body: some View {
        VStack {
            Text("Choose your background")
                .foregroundColor(.white)
                .padding()
                .font(Font.custom("Inter-Bold", size: 20))

            HStack {
                BackgroundButton(isPressed: $isPressed[0], image: "blueGradient", pressedImage: "blueGradientPressed", action: { backgroundImage = "blueGradientBackground" })
                BackgroundButton(isPressed: $isPressed[1], image: "redGradient", pressedImage: "redGradientPressed", action: { backgroundImage = "redGradientBackground" })
                BackgroundButton(isPressed: $isPressed[2], image: "greenGradient", pressedImage: "greenGradientPressed", action: { backgroundImage = "greenGradientBackground" })
            }
        }
    }
}
